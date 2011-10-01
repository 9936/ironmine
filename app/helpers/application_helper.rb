module ApplicationHelper
  def common_title(options={:model_meaning=>"",:model_name=>"",:action_meaning=>"",:show_data=>""})
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
      if current_tab
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

    content = raw(content_tag(:div, raw(title)+raw(image_icon)+raw(description), :class => "content"))

    pt_body = raw(content_tag(:div, content, :class => "pt-body"))
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


    content = raw(content_tag(:div, raw( description), :class => "content"))

    content_for :html_title,do
      title
    end
    pt_body = raw(content_tag(:div, content, :class => "pt-body"))
    b_page_title = raw(content_tag(:div, pt_body, :class => "page-title"))
    raw(b_page_title)
  end




  def page_title(title = "", description = "")
    common_title(:model_meaning=>title,:action_meaning=>description)
    #page_title = ""
    #page_description = ""
    #b_description = ""
    #if @current_menu_entry && @current_menu_entry.page_controller
    #  if @current_menu_entry.icon
    #    page_description << content_tag(:img, "", :src => '/images/s.gif', :class => @current_menu_entry.icon + " page-title-icon")
    #  end
    #  if !title.blank?
    #    page_title << content_tag(:h1, title, :class => "pageType")
    #  else
    #    page_title << content_tag(:h1, @current_menu_entry[:name], :class => "pageType")
    #  end
    #  if !description.blank?
    #    page_description << content_tag(:h2, description, :class => "pageDescription")
    #  else
    #    page_description << content_tag(:h2, t("label_action_#{params[:action]}".to_s), :class => "pageDescription")
    #  end
    #  if !@current_menu_entry[:description].blank?
    #    b_description << content_tag(:div, @current_menu_entry[:description], :class => "bDescription")
    #  end
    #else
    #  page_title << content_tag(:h1, title, :class => "pageType")
    #  page_description << content_tag(:h2, description, :class => "pageDescription")
    #end
    #content = raw(content_tag(:div, raw(page_title + page_description), :class => "content"))
    #pt_body = raw(content_tag(:div, content, :class => "pt-body"))
    #b_page_title = raw(content_tag(:div, pt_body, :class => "page-title"))
    #raw(b_page_title)
  end

  def setting_title(options = {:title => "", :description => ""})
    common_title(:model_meaning=>options[:title],:action_meaning=>options[:description])
    #page_title = ""
    #page_description = ""
    #b_description = ""
    #if @current_menu_entry&&@current_menu_entry.page_controller
    #  t_title = ""
    #  if options[:title] && !options[:title].blank?
    #    t_title << options[:title] + ": "
    #  else
    #    t_title << @current_menu_entry[:name] + ": "
    #  end
    #  if options[:description] && !options[:description].blank?
    #    t_title << options[:description]
    #  else
    #    t_title << t("label_action_#{params[:action]}".to_s)
    #  end
    #  page_description << content_tag(:h2, t_title, :class => "pageDescription")
    #  if !@current_menu_entry[:description].blank?
    #    b_description << content_tag(:div, @current_menu_entry[:description], :class => "bDescription")
    #  end
    #else
    #  page_title << content_tag(:h1, options[:title], :class => "pageType")
    #  page_description << content_tag(:h2, options[:description], :class => "pageDescription")
    #end
    #content = raw(content_tag(:div, raw(page_title + page_description), :class => "content"))
    #pt_body = raw(content_tag(:div, content, :class => "pt-body"))
    #b_page_title = raw(content_tag(:div, pt_body, :class => "page-title"))
    #raw(b_page_title)
  end

  def app_title(options = {:title => "", :description => ""})
    common_title(:model_meaning=>options[:title],:action_meaning=>options[:description])
    #page_title = ""
    #page_description = ""
    #b_description = ""
    #p_help = ""
    #p_href = ""
    #if @current_menu_entry && @current_menu_entry.page_controller
    #  if @current_menu_entry.icon
    #    page_description << content_tag(:img, "", :src => '/images/s.gif', :class => @current_menu_entry.icon + " page-title-icon")
    #  end
    #  t_title = ""
    #  if params[:title] && !params[:title].blank?
    #    t_title << options[:title] + ": "
    #  else
    #    t_title << @current_menu_entry[:name] + ": "
    #  end
    #  if options[:description] && !options[:description].blank?
    #    t_title << options[:description]
    #  else
    #    t_title << t("label_action_#{params[:action]}".to_s)
    #  end
    #  page_description << content_tag(:h2, t_title, :class => "pageDescription")
    #  if !@current_menu_entry[:description].blank?
    #    b_description << content_tag(:div, @current_menu_entry[:description], :class => "bDescription")
    #  end
    #else
    #  page_title << content_tag(:h1, params[:title], :class => "pageType")
    #  page_description << content_tag(:h2, params[:description], :class => "pageDescription")
    #end
    #p_href << content_tag(:a, t(:current_page_help),:href => "#",:onclick=>"window.open ('/pagehelpfiles/#{Irm::Permission.page_help_url(params[:controller],params[:action])}.html', 'Ironmine_Help', 'height=800px, width=870px, top=0, left=0, toolbar=no, menubar=no,scrollbars=yes, location=no, status=no');" )
    #p_help =raw(content_tag(:div,raw(p_href),:class=>"links"))
    #content = raw(content_tag(:div, raw(page_title + page_description), :class => "content"))
    #pt_body = raw(content_tag(:div, raw(content+p_help), :class => "pt-body"))
    #b_page_title = raw(content_tag(:div, pt_body, :class => "page-title"))
    #raw(b_page_title)
  end

  def setting_show_title(options = {})
    common_title(:model_meaning=>options[:title],:action_meaning=>options[:description],:show_data=>options[:show_data])
    #page_title = ""
    #page_description = ""
    #b_description = ""
    #if @current_menu_entry && @current_menu_entry.page_controller
    #  if @current_menu_entry.icon
    #    page_description << content_tag(:img, "", :src => '/images/s.gif', :class => @current_menu_entry.icon + " page-title-icon")
    #  end
    #  if options[:title] && !options[:title].blank?
    #    page_title << content_tag(:h1, options[:title], :class => "pageType")
    #  else
    #    page_title << content_tag(:h1, @current_menu_entry[:name], :class => "pageType")
    #  end
    #  if options[:show_data] && !options[:show_data].blank?
    #    page_description << content_tag(:h2, options[:show_data], :class => "pageDescription")
    #  end
    #  if !@current_menu_entry[:description].blank?
    #    b_description << content_tag(:div, @current_menu_entry[:description], :class => "bDescription")
    #  end
    #else
    #  page_title << content_tag(:h1, options[:title], :class => "pageType")
    #  page_description << content_tag(:h2, options[:description], :class => "pageDescription")
    #end
    #content = raw(content_tag(:div, raw(page_title + page_description), :class => "content"))
    #pt_body = raw(content_tag(:div, content, :class => "pt-body"))
    #b_page_title = raw(content_tag(:div, pt_body, :class => "page-title"))
    #raw(b_page_title)
  end

  def app_show_title(options = {})
    common_title(:model_meaning=>options[:title],:action_meaning=>options[:description],:show_data=>options[:show_data])

    #page_title = ""
    #page_description = ""
    #b_description = ""
    #p_href = ""
    #if @current_menu_entry && @current_menu_entry.page_controller
    #  if options[:title] && !options[:title].blank?
    #    page_title << content_tag(:h1, options[:title], :class => "pageType")
    #  else
    #    page_title << content_tag(:h1, @current_menu_entry[:name], :class => "pageType")
    #  end
    #  if options[:show_data] && !options[:show_data].blank?
    #    page_description << content_tag(:h2, options[:show_data], :class => "pageDescription")
    #  end
    #  if !@current_menu_entry[:description].blank?
    #    b_description << content_tag(:div, options[:description], :class => "bDescription")
    #  end
    #else
    #  page_title << content_tag(:h1, options[:title], :class => "pageType")
    #  page_description << content_tag(:h2, options[:description], :class => "pageDescription")
    #end
    #p_href << content_tag(:a, t(:current_page_help),:href => "#",:onclick=>"window.open ('/pagehelpfiles/#{Irm::Permission.page_help_url(params[:controller],params[:action])}.html', 'Ironmine_Help', 'height=800px, width=870px, top=0, left=0, toolbar=no, menubar=no,scrollbars=yes, location=no, status=no');" )
    #p_help =raw(content_tag(:div,raw(p_href),:class=>"links"))
    #content = raw(content_tag(:div, raw(page_title + page_description), :class => "content"))
    #pt_body = raw(content_tag(:div, raw(content+p_help), :class => "pt-body"))
    #b_page_title = raw(content_tag(:div, pt_body, :class => "page-title"))
    #raw(b_page_title)
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
     lis<<content_tag(:li,msg,nil,false)
    end
    uls=content_tag(:ul,lis,nil,false)
    h2s=content_tag(:h2,"Errors",nil,false)
    if error_count>0
      content_tag(:div,content_tag(:div, raw("#{h2s}\n#{uls}"), {:class=>"errormsgbox"}) ,{:id=>"system_message_box"},false)
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

  # 生成YUI表格
  def datatable(id,source_url,columns,options={})
    row_perpage = options[:row_perpage]||10
    search_box = options[:search_box]
    paginator_box = options[:paginator_box]
    paginator_perpage = options[:paginator_perpage]||true
    export_data = options[:export_data]||"_none_"
    select = options[:select]
    columns.insert(0,{:key=>"dt_selector",:width=>"36px"}) if select&&(select.eql?("multiple")||select.eql?("single"))
    columns_conf = ""
    data_fields = ""
    columns.each do |c|
      data_fields << %Q("#{c[:field]||c[:key]}",)
      next if c[:hidden]
      column = "{"
      c.each do |key,value|
        if(!key.to_s.eql?("formatter"))
          column << %Q(#{key.to_s}:"#{value}",)
        else
          column << %Q(#{key.to_s}:#{value},)
        end
      end
      columns_conf << column.chop
      columns_conf << "},"
    end
    columns_conf.chop!
    data_fields.chop!


    load_str = "#{id}Datatable.datasource.load()"
    load_str = "//does not load at init" if options[:not_load]

    search_str = ""
    search_str = ".plug(Y.Plugin.IrmDTSearchBox,{searchDom:'#{search_box}'})" if search_box

    paginator_str = ""
    paginator_str = ".plug(Y.Plugin.IrmDTPaginator,{paginatorDom:'#{paginator_box}',rowPerPage:false})" if paginator_box&&!paginator_perpage
    paginator_str = ".plug(Y.Plugin.IrmDTPaginator,{paginatorDom:'#{paginator_box}',exportDataDom:'#{export_data}',
                                                    paginatorLabels:{record:'#{t(:paginator_record)}',
                                                                     rowPerPage:'#{t(:paginator_rowperpage)}',
                                                                     prepage:'#{t(:paginator_prepage)}',
                                                                     nextpage:'#{t(:paginator_nextpage)}',
                                                                     page:'#{t(:paginator_page)}'}})" if paginator_box&&paginator_perpage


    select_str = ""
    select_str = ".plug(Y.Plugin.IrmDTSelector,{mode:'multiple'})" if select&&select.eql?("multiple")
    select_str = ".plug(Y.Plugin.IrmDTSelector,{mode:'single'})" if select&&select.eql?("single")

    script = %Q(GY.use("irm","datasource-get", "datasource-jsonschema","dtdatasource","dtsort","dtsearchbox","dtselector","dtcolwidth","dtpaginator",function(Y) {
       Y.on("domready",function(){
         var #{id}Cols = [#{columns_conf}],
         #{id}Datasource = new Y.DataSource.Get({source:'#{source_url}'})
                   .plug(Y.Plugin.DataSourceJSONSchema, {
                      schema: {
                        metaFields: {numRows:"numRows"},
                        resultListLocator: "items",
                        resultFields: [#{data_fields}]
             }
         }),
         #{id}Datatable = new Y.DataTable.Base({columnset:#{id}Cols})
             .plug(Y.Plugin.IrmDTDataSource, {datasource:#{id}Datasource})#{select_str}.plug(Y.Plugin.IrmDTSort)#{search_str}#{paginator_str}.plug(Y.Plugin.IrmDTColWidth).render("##{id}");
         #{id}Datatable.datasource.paginate({start:0,count:#{row_perpage}},false);
         #{load_str}
         Y.irm.setAttribute('#{id}Datatable',#{id}Datatable,'Datatable');
        });
     });)
    javascript_tag(script)
  end

  def autocomplete(id,source_url,columns,options={})
    columns_conf = []
    data_fields = []
    return_tos = []
    columns.each do |c|
      data_fields << %Q("#{c[:key]||c[:field]}")
      return_tos << %Q(#{c[:key]||c[:field]}:"#{c[:return_to]}")  if c[:return_to]&&!"#{c[:return_to]}".eql?("##{id}")
      next if c[:hidden]
      column = "{"
      c.each do |key,value|
        if(!key.to_s.eql?("width"))
          column << %Q(#{key.to_s}:"#{value}",)
        else
          column << %Q(#{key.to_s}:#{value},)
        end
      end
      columns_conf << column.chop
      columns_conf << "}"
    end
    script = %Q(
         GY.use("irmac","datasource-get", "datasource-jsonschema",function(Y){
         var #{id}ACDS = new Y.DataSource.Get({source:"#{source_url}"}).plug(Y.Plugin.DataSourceJSONSchema, {
                             schema: {
                               metaFields: {numRows:"numRows"},
                               resultListLocator: "items",
                               resultFields: [#{data_fields.join(",")}]
                    }
          })
         Y.one("##{id}").plug(Y.irmac.AutoComplete,{zIndex:1000,inputNode:"##{id}",source:#{id}ACDS,returnValues:{#{return_tos.join(",")}},displayConfigs:[#{columns_conf.join(",")}]});
         });
    )
    javascript_tag(script)
  end

  def tabview(id, srcs = {})
    script = %Q(
      GY.use("tabview", "gallerywidgetio", "async-queue", function(Y) {
          TabIO = function(config) {
              TabIO.superclass.constructor.apply(this, arguments);
          };

          Y.extend(TabIO, Y.Plugin.WidgetIO, {
              initializer: function() {
                  var tab = this.get('host');
                  tab.on('selectedChange', this.afterSelectedChange);
                  tab.on('contentUpdate', this.contentUpdate);
                  tab.get('panelNode').on('contentUpdate', this.contentUpdate);
              },
              contentUpdate:function(e){
                  alert("test");
              },
              afterSelectedChange: function(e) { // this === tab
                  if (e.newVal) { // tab has been selected
                      this.io.refresh();
                  }
              },
              setContent: function(content) {
                  var tab = this.get('host');
                  tab.set('content', content);
              },
              _toggleLoadingClass: function(add) {
                  this.get('host').get('panelNode')
                      .toggleClass(this.get('host').getClassName('loading'), add);
              }
          }, {
              NAME: 'tabIO',
              NS: 'io'
          });

          var feeds = #{srcs.to_json};
          var tabview = new Y.TabView();
          Y.each(feeds, function(src, label) {
              tabview.add({
                  label: label,
                  plugins: [{
                      fn: TabIO,
                      cfg: {
                          uri: src
                      }
                  }]
              });
          });
          tabview.render('##{id}');
      });
    )
    javascript_tag(script);
  end

  def error_for(object)
    if object && object.errors && object.errors.any?
      content_tag("div", raw(t(:error_invalid_data) + "<br>" + t(:check_error_msg_and_fix)), {:id => "errorDiv_ep", :class => "pbError"})
    end
  end

  def flash_notice
    ret = ""
    ret = content_tag("div", raw(flash[:notice]), {:id => "succDiv_ep", :class => "pbSucc"}) if flash[:notice].present?
    ret = content_tag("div", raw(flash[:error]), {:id => "errorDiv_ep", :class => "pbError"}) if flash[:error].present?
    ret
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
  
  def link_back(text = t(:back))
    link_to text, {}, {:href => "javascript:history.back();"}
  end

  #构建日历控件，其中text_field是输入的日期框，id_button是点击日历的
  #button，而id_cal是日历显示的ID，最好不一致
  def calendar_view(id_text_field,id_button,id_cal)
    script = %Q(
       GY.use( 'yui2-calendar','yui2-container','calendarlocalization#{I18n.locale.to_s}',function(Y) {
            var YAHOO = Y.YUI2;
            var Event = YAHOO.util.Event,Dom = YAHOO.util.Dom;
             YAHOO.util.Event.onDOMReady(function () {
                show_irm_calendar(YAHOO,Event,Dom,"#{id_button}","#{id_text_field}","#{id_cal}", yui_calendar_custom_cfg);
             });
       });
    )
    javascript_tag(script)
  end

  def format_date(time)
    time.strftime('%Y-%m-%d %H:%M:%S')
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

  #简单讲hash和数组中的数据转换成图表所需要的数据
   def to_chart_json(chart_data)
      json = %Q([)
      if chart_data.is_a?(Hash)
        chart_data.each do |key,value|
          json << %Q({category:"#{key}",value:#{value}},)
        end
        json.chomp!(",")
      elsif chart_data.is_a?(Array)
        chart_data.each do |elem|
          json << %Q({category:"#{elem[0]}",value:#{elem[1]}},)
        end
        json.chomp!(",")
      end
      json << "]"
      json
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
end
