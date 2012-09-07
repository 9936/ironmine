module ApplicationHelper
  def common_title(options={:model_meaning=>"",:model_name=>"",:action_meaning=>"",:show_data=>"", :buttons => ""})
    model_title = ""
    if options[:model_meaning].present?
      model_title = options[:model_meaning]
    else
      if options[:model_name].present?
        model_title = Irm::BusinessObject.class_name_to_meaning(options[:model_name])
      else
        model_title = Irm::BusinessObject.class_name_to_meaning(params[:controller].classify)
      end
    end


    action_title = options[:action_meaning]
    action_title = t("label_action_#{params[:action]}".to_s) unless action_title.present?

    if Irm::Application.current&&Irm::FunctionGroup.current
      current_tab = Irm::Tab.multilingual.with_function_group(I18n.locale).query_by_application(Irm::Application.current.id).where("#{Irm::FunctionGroup.view_name}.id = ?",Irm::FunctionGroup.current).first
      if current_tab && options[:buttons].present?
        button_title(current_tab,model_title,action_title,options[:show_data], options[:buttons])
      elsif current_tab
        common_app_title(current_tab,model_title,action_title,options[:show_data])
      else
        common_setting_title(model_title,action_title,options[:show_data])
      end
    else
      common_setting_title(model_title,action_title,options[:show_data])
    end
  end

  def common_app_title(current_tab,model_title,action_title,data_meaning)
    image_icon = ""
    if current_tab.style_image
      image_icon << content_tag(:img, "", {:src => '/images/s.gif', :class => current_tab.style_image + " page-title-icon"},false)
    else
      image_icon << content_tag(:img, "", {:src => '/images/s.gif', :class => "img1General page-title-icon"},false)
    end
    title = model_title
    if data_meaning.present?
      action_title = action_title+":"+data_meaning
    end


    description = content_tag(:h2, action_title, :class => "page-description")

    content_for :html_title,do
      title+":"+action_title
    end

    title =  content_tag(:h1, title, :class => "page-type")

    content = raw(content_tag(:div, raw(title)+raw(image_icon)+raw(description), :class => "page-title-content"))

    pt_body = raw(content_tag(:div, content, :class => "page-title-body"))
    b_page_title = raw(content_tag(:div, pt_body, :class => "page-title"))
    raw(b_page_title)
  end

  def common_setting_title(model_title,action_title,data_meaning)

    title = model_title
    if data_meaning.present?
      title = title+":"+data_meaning
    else
      title = model_title+":"+action_title
    end

    description = content_tag(:h2, title, :class => "page-description")


    content = raw(content_tag(:div, raw( description), :class => "page-title-content"))

    content_for :html_title,do
      title
    end
    pt_body = raw(content_tag(:div, content, :class => "page-title-body"))
    b_page_title = raw(content_tag(:div, pt_body, :class => "page-title"))
    raw(b_page_title)
  end

  def button_title(current_tab,model_title,action_title,data_meaning,buttons)

    title = model_title
    if data_meaning.present?
      title = title+":"+data_meaning
    else
      title = model_title+":"+action_title
    end

    description = content_tag(:h1, title, :class => "page-type no-second-header")


    content = raw(content_tag(:div, raw( description) + raw(content_tag(:div, "", :class => "blank")), :class => "page-title-content"))
    button_tag = raw(content_tag(:div, raw(buttons) ,:class => "add-new-buttons"))
    content_for :html_title,do
      title
    end
    pt_body = raw(content_tag(:div, content + button_tag, :class => "page-title-body"))
    b_page_title = raw(content_tag(:div, pt_body, :class => "page-title noicon"))
    raw(b_page_title)
  end


  def page_title(title = "", description = "")
    common_title(:model_meaning=>title,:action_meaning=>description)
  end

  def setting_title(options = {:title => "", :description => ""})
    common_title(:model_meaning=>options[:title],:action_meaning=>options[:description])
  end

  def app_title(options = {:title => "", :description => ""})
    common_title(:model_meaning=>options[:title],:action_meaning=>options[:description])
  end

  def setting_show_title(options = {})
    common_title(:model_meaning=>options[:title],:action_meaning=>options[:description],:show_data=>options[:show_data])
  end

  def app_show_title(options = {})
    common_title(:model_meaning=>options[:title],:action_meaning=>options[:description],:show_data=>options[:show_data])
  end  


  def form_require_info
    raw "<span class='required-help-info'> = #{t(:label_is_required)}</span> "
  end
  #显示form提交的出错信息
  def error_message_for(*args)
    lis=""
    error_count = 0
    full_messages = []
    args.each do |instance|
       if instance.errors&&instance.errors.any?
          instance.errors.each do | attr,msg|
            full_messages<<t(("label_#{instance.class.name.underscore.gsub(/\//, "_")}_" + attr.to_s.gsub(/\_id$/, "")).to_sym)+" #{msg}"
          end
          error_count+=instance.errors.count
       end
    end
    full_messages.each do |msg|
     lis<<content_tag(:div,msg,nil,false)
    end
    if error_count>0
      content_tag(:div,content_tag(:div, raw("#{lis}"), {:class=>"alert alert-error"}) ,{:id=>"system_message_box"},false)
    else
      nil
    end
  end

  def succ_message_for(msg)
    content_tag(:div,content_tag(:div, raw(msg), {:class=>"succmsgbox"}) ,{:id=>"system_message_box"},false)
  end

  # 确认当前用户是否有权限访问链接
  # 页面上的链接数量太多，采用缓存将页面permission信息存储
  def allow_to?(url_options={})
    Irm::PermissionChecker.allow_to_url?(url_options)
  end

  # datatable的参数
  # id : 表格对应div的id,页面上必须存在此div
  # url_options : 表格数据来源url,以hash形式传入
  # coluns : 表格列定义
  # options: 表格显示参数
  #     1, select 表格是否需要显示checkbox选择列，默认为空
  #     2, html 是否在性能较差的设备上使用html表格代替extjs的表格
  #     3, force_html 是否强制使用html表格
  #     4, row_perpage 分页时一个页面上显示多少行数据
  #     5，search_box 搜索框对应的div
  #     6, view_filter 是否使用表格过滤器
  #     7, paginator_box 翻页器显示的div的ID
  # 表格列属性
  #     1,key 对应数据的字段
  #     2,label 列标题
  #     3,width 宽度
  #     4,formatter 列数据显示方式
  def datatable(id,url_options,columns,options={})

    select = options[:select]
    html = options[:html]||false
    return plain_datatable(id,url_options,columns,options)

  end



  def plain_datatable(id,url_options,columns,options={})

    output = ActiveSupport::SafeBuffer.new
    output.safe_concat "<div id='#{id}'></div>"

    source_url = url_for(url_options.merge(:format=>:html,:back_url=>url_for({})))

    page_size = options[:row_perpage]||10

    search_box = options[:search_box]
    paginator_box = options[:paginator_box]
    export_box = options[:export_data]

    #select 配置
    select_type = options[:select]


    column_models = ""
    columns.each do |c|
      next if c[:hidden]||(!c[:searchable].present? && !c[:orderable].present?)
      column = "{"
      c.each do |key,value|
        case key
          when :key
            column << %Q(dataIndex:"#{value}",)
          when :label
            column << %Q(text:"#{value}",)
          when :searchable
            column << %Q(searchable:#{value},)
          when :orderable
            column << %Q(orderable:#{value},)
        end
      end
      column_models <<  column.chop
      column_models << "},"
    end
    column_models.chop!



    table_options = "columns:[#{column_models}],baseUrl:'#{source_url}',pageSize:#{page_size}"

    if search_box
      table_options << ",searchBox:'#{search_box}'"
    end

    if paginator_box
      table_options << ",paginatorBox:'#{paginator_box}'"
      output.safe_concat "<div id='#{paginator_box}'></div>"
    end
    if export_box
      table_options << ",exportBox:'#{export_box}'"
    end

    if select_type
      table_options << ",selectType:'#{select_type}'"
    end

    if options[:view_filter]
      table_options << ",filterBox:'#{id}ViewFilterOverview'"
    end

    if options[:scroll]
      scroll_options = {}
      scroll_mode = nil
      if options[:scroll].is_a?(Hash)
        scroll_mode = options[:scroll][:mode]
        scroll_options = options[:scroll]
      elsif options[:scroll].is_a?(String)
        scroll_mode =  options[:scroll]
        scroll_options = {:mode=>scroll_mode}
      end

      if scroll_mode.include?("x")
        scroll_options[:scrollX] = true
      end
      if scroll_mode.include?("y")
        scroll_options[:scrollY] = true
        if  scroll_options[:height]
          scroll_options[:staticY]=true
        else
          scroll_options[:height]=235
        end

      end

      table_options << ",scrollOptions:#{scroll_options.to_json}"
    end

    table_options = "{#{table_options}}"


    script = %Q(
        $(function(){$('##{id}').datatable(#{table_options})});
    )

    output.safe_concat javascript_tag(script)
    output
  end




  def error_for(object)
    if object && object.errors && object.errors.any?
      content_tag :div,{:id => "errorDiv_ep", :class => "alert alert-error"} do
        error = raw(t(:error_invalid_data) + "<br>" + t(:check_error_msg_and_fix))
        error += raw("<br>" + flash[:error]) if flash[:error].present?
        error
      end
    end
  end

  def flash_notice
    if flash[:notice].present?
      content_tag :div, {:id => "succDiv_ep", :class => "alert alert-success"} do
        raw("<a href='javascript:void(0);' class='close' data-dismiss='alert'>&times</a>" + "<p>#{flash[:notice]}</p>")
      end
    end
  end

  #重写content_for方法,当调用content_for时,修改has_content
  def content_for(name, content = nil, &block)
    @has_content ||= {}
    @has_content[name] = true
    super(name, content, &block)
  end

  #利用@has_content来判断是否存在name content
  def has_content?(name)
    (@has_content && @has_content[name]) || false
  end
  
  def link_back(text = t(:back),default_options={},html_options={})
    if params[:back_url].present?
      link_to text, {}, html_options.merge({:href => CGI.unescape(params[:back_url].to_s)})
    elsif default_options.any?
      link_to text, default_options ,html_options
    else
      link_to text, {}, html_options.merge({:href => "javascript:history.back();"})
    end
  end

  def link_submit(text = t(:save),options={})
    link_to text, {}, {:type=>"submit",:href => "javascript:void(0);"}.merge(options)
  end

  #构建日历控件，其中text_field是输入的日期框，id_button是点击日历的
  #button，而id_cal是日历显示的ID，最好不一致
  def calendar_view(id_text_field,id_button,id_cal)
    #script = %Q(
    #   GY.use( 'yui2-calendar','yui2-container','calendarlocalization#{I18n.locale.to_s}',function(Y) {
    #        var YAHOO = Y.YUI2;
    #        var Event = YAHOO.util.Event,Dom = YAHOO.util.Dom;
    #         YAHOO.util.Event.onDOMReady(function () {
    #            show_irm_calendar(YAHOO,Event,Dom,"#{id_button}","#{id_text_field}","#{id_cal}", yui_calendar_custom_cfg);
    #         });
    #   });
    #)
    #javascript_tag(script)
  end

  def format_date(time)
    return time if time&&time.is_a?(String)
    time.strftime('%Y-%m-%d %H:%M:%S') if time
  end

  def calendar_date(time)
    return time if time && time.is_a?(String)
    time.strftime('%Y-%m-%d') if time
  end

  def show_check_box(value = "", y_value = "")
    tags = ""
    if !y_value.blank?
      value = Irm::Constant::SYS_YES if value == y_value
    end
    if value == Irm::Constant::SYS_YES
      tags << content_tag(:img, "",
                          {:class => "checkImg", :width => "21", :height => "16",
                           :title => I18n.t(:label_checked), :alt => I18n.t(:label_checked),
                           :src => theme_image_path("checkbox_checked.png") })
    else
      tags << content_tag(:img, "",
                          {:class => "checkImg", :width => "21", :height => "16",
                           :title => I18n.t(:label_unchecked), :alt => I18n.t(:label_unchecked),
                           :src => theme_image_path("checkbox_unchecked.png") })
    end
    raw(tags)
  end

  def check_img(value = "")
     content_tag(:img, "",{:class => "checkImg", :width => "21", :height => "14",
                           :src => theme_image_path("#{value}.png") }) if !value.blank?
  end

  def show_date(options={})
     advance = options[:months_advance]||0
     (Time.now.advance(:months => advance)).strftime("%Y-%m-%d").to_s
  end

  def link_to_checker(body, url_options = {}, html_options = {})
    if Irm::PermissionChecker.allow_to_url?(url_options)
      return link_to(body, url_options, html_options)
    end
    ""
  end


  def allow_to_function?(function)
    Irm::PermissionChecker.allow_to_function?(function)
  end

  def current_person?(person_id)
    (person_id&&Irm::Person.current.id.to_s.eql?(person_id.to_s))
  end

  def blank_select_tag(name, collection,selected=nil, options = {})
    choices = options_for_select(collection, selected)
    html_options=({:prompt=>"--- #{I18n.t(:actionview_instancetag_blank_option)} ---",
                                 :blank=> "--- #{I18n.t(:actionview_instancetag_blank_option)} ---"}).merge(options||{})
    select_tag(name, choices,html_options)
  end

  def select_tag_alias(name, collection,selected=nil, options = {})
    choices = options_for_select(collection, selected)
    select_tag(name, choices,options)
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

  def info_icon(info = "")
    tag = content_tag(:img, "",:src => "/images/s.gif", :class => "infoIcon", :title => info, :alt => info)
    raw(tag)
  end

  def toggle_img(class_name,toggled=false,options={})
    image_options = {}
    if toggled
      image_options.merge!(:class=>"#{class_name}On")
    else
      image_options.merge!(:class=>class_name)
      image_options.merge!({:onmouseover=>"this.className = '#{class_name}On';this.className = '#{class_name}On';", :onmouseout=>"this.className = '#{class_name}';this.className = '#{class_name}';",:onfocus=>"this.className = '#{class_name}On';",:onblur=>"this.className = '#{class_name}';"})
    end
    image_options.merge!(options)
    image_tag("/images/s.gif",image_options)
  end

  # 页面添加bootstrap javascript css文件，防止重复添加
  def require_jscss(name)
    @loaded_jscss_files ||= []

    if name.is_a?(String)||name.is_a?(Symbol)
      @loaded_jscss_files << name.to_sym
    elsif name.is_a?(Array)
      name.each do |file|
        @loaded_jscss_files << file.to_sym
      end
    end
  end

  def render_required_jscss
    javascript_files = []
    css_files = []
    javascript_prefix = ""
    css_prefix =""
    @loaded_jscss_files.uniq!
    Ironmine::Application.config.fwk.jscss.each do |name,paths|
      if @loaded_jscss_files.include?(name)

        paths[:js].each do |path|
          javascript_files << path
        end if paths[:js]
        paths[:css].each do |path|
          css_files << path
        end if paths[:css]
      end
    end if @loaded_jscss_files


    file_links = ""

    css_files.uniq.each do |css_file|
      file = css_file.to_s.gsub("{locale}",I18n.locale.to_s).to_sym
      file_links << stylesheet_link_tag(file)
    end
    javascript_files.uniq.each do |script_file|

      file = script_file.to_s.gsub("{locale}",I18n.locale.to_s).to_sym
      file_links << javascript_include_tag(file)
    end

    raw file_links
  end

  def controller_action_css_class
    "#{params[:controller]}".gsub("/","-").gsub("_","-")
  end

  # 判断浏览器是否为ie6
  def ie6?
    ies = request.user_agent.scan(/MSIE \d\.\d*/)
    ies.any?&&ies[0].include?("MSIE 6.0")
  end

  # 将使用IE6和Android 2的设备设置为限制设备
  def limit_device?
    ie6? || request.user_agent.include?("Android 2") || request.user_agent.include?("iPad")||request.user_agent.include?("iPhone")
  end

  #xheditor编辑器
  def xheditor(textarea_id,force_fit_width=false,shortcuts = false)
    unless limit_device?
      require_jscss(:xheditor)
      render :partial=>"helper/xheditor",:locals=>{:textarea_id=>textarea_id,:force_fit_width=>force_fit_width, :shortcuts => shortcuts}
    end
  end

  def options_for(klass,value_field="id",label_field="name")
    data_scope = []
    if klass.respond_to?(:multilingual)
      data_scope = klass.multilingual.enabled
    else
      data_scope = klass.enabled
    end
    data_scope.collect{|i| [i[label_field.to_sym],i[value_field.to_sym]]}
  end

  def tabs(name,tabs_configs)
    output = ActiveSupport::SafeBuffer.new
    output.safe_concat("<ul class='nav nav-tabs'>")
    tabs_configs.each_with_index do |config,index|
      selected = params[:controller].eql?(config[:url][:controller])&&params[:action].eql?(config[:url][:action])
      tab_id = config[:id]||"#{name}_#{index}"
      if selected
        output.safe_concat("<li id='#{tab_id}' class='active'>")
      else
        output.safe_concat("<li id='#{tab_id}'>")
      end
      output.safe_concat(link_to(config[:label],config[:url].merge(config[:params])))
      output.safe_concat("</li>")
    end
    output.safe_concat("</ul>")
    output
  end

  def mx_tabs(name,tabs_configs)
    output = ActiveSupport::SafeBuffer.new
    output.safe_concat("<div class='mx-tabs'><ul class='clear-fix'>")
    tabs_configs.each_with_index do |config,index|
      selected = params[:controller].eql?(config[:url][:controller])&&params[:action].eql?(config[:url][:action])
      tab_id = config[:id]||"#{name}_#{index}"
      if selected
        output.safe_concat("<li id='#{tab_id}' class='active'>")
      else
        output.safe_concat("<li id='#{tab_id}'>")
      end
      output.safe_concat(link_to(config[:label],config[:url].merge(config[:params])))
      output.safe_concat("</li>")
    end
    output.safe_concat("</ul></div>")
  end


  def custom_escape_javascript(javascript)
    result = (javascript || '').
        gsub('\\', '\\\\\\').
        gsub(/\r\n|\r|\n/, '\\n').
        gsub(/['"]/, '\\\\\&').
        gsub('</script>','</scr"+"ipt>')
    result
  end

  def  get_contrast_yiq(hex_color)
    return "black" unless hex_color&&hex_color.is_a?(String)&&hex_color.length>5&&hex_color.length<8
    hex_color = hex_color.gsub("#","")
  	r = hex_color[0..1].to_i(16)
  	g = hex_color[2..3].to_i(16)
    b = hex_color[4..5].to_i(16)
  	yiq = ((r*299)+(g*587)+(b*114))/1000;
  	return (yiq >= 128) ? 'black' : 'white';
  end



  # 上传文件控件
  # options  :upload_file_id=>"new_wiki",:url_options=>{:source_id=>"nil",:source_type=>@wiki.class.name},:file_type=>"doc",:pasted_zone=>"gollum-editor-body"
  # upload_file_id 控件ID
  # url_options 文件上传url
  # file_type 文件类型
  # limit 文件大小 以M为单位
  # pasted_zone 粘贴上传文件dom id
  def upload_file_sample(options)
    processed_options = options
    message = []
    message << options[:message] if options[:message].present?
    if options[:limit].present?
      processed_options[:limit] = options[:limit]*1024*1024
      message << t(:label_attachment_file_size_limit,:limit=>"#{options[:limit]}M")
    end

    if options[:file_type].present?
      message << t(:label_attachment_file_type,:type=>"#{options[:file_type]}")
    end

    processed_options[:message] = "(#{message.join(",")})" if message.any?

    render :partial=>"helper/upload_file_sample",:locals=>processed_options
  end


  def theme_image_path(path)
    image_path(path)
  end


end
