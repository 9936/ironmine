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
    force_html = true #options[:force_html]||false

    if force_html||(html&&limit_device?&&!select.present?)
      return plain_datatable(id,url_options,columns,options)
    else
      require_javascript(:extjs)
      require_css(:extjs)
    end

    source_url = url_for(url_options.merge(:format=>:json,:back_url=>url_for({})))
    page_size = options[:row_perpage]||10
    search_box = options[:search_box]
    height = options[:height]||300

    data_fields = ""
    column_models = ""
    columns.each do |c|
      data_fields << %Q("#{c[:field]||c[:key]}",)
      next if c[:hidden]
      column = "{"
      c.each do |key,value|
        case key
          when :key
            column << %Q(dataIndex:"#{value}",)
          when :label
            column << %Q(text:"#{value}",)
          when :width
            if(value.include?("px"))
              column << %Q(width:#{value.gsub("px","")},)
              column << %Q(flex:0,)
            elsif(value.include?("%"))
              column << %Q(width:#{value.gsub("%","")},)
              column << %Q(flex:0,)
            elsif value.present?
              column << %Q(width:#{value},)
              column << %Q(flex:0,)
            end
          #when :sortable
          #  column << %Q(sortable:false,)
          when :formatter
            if value.eql?("Y.irm.template")||value.eql?("template")
              column << %Q(renderer: Ext.irm.dtTemplate,)
            elsif value.eql?("Y.irm.stemplate")||value.eql?("script_template")
              column << %Q(renderer: Ext.irm.dtScriptTemplate,)
            end
          when :searchable
            column << %Q(searchable:#{value},)
          when :locked
            column << %Q(locked:#{value},)
        end


      end
      unless column.include?("flex")
        column << %Q(flex:1,)
      end
      column << %Q(sortable:false,)
      column << %Q(menuDisabled:true,)
      column_models <<  column.chop
      column_models << "},"
    end
    column_models.chop!
    data_fields.chop!

    load_str = "#{id}DatatableStore.loadPage(1);"
    load_str = "//does not load #{id}Datatable data" if options[:not_load]

    view_filter_str = "// No view filter for #{id}Datatable"
    if options[:view_filter]
      view_filter_str = "Ext.create('Ext.irm.ViewFilter',{filter:'#{id}ViewFilterOverview',table:#{id}Datatable});"
      load_str = "//does not load #{id}Datatable data,because of view filter #{options[:view_filter]}"
    end

    search_str = "// Now Search Box for #{id}Datatable"
    if search_box
      search_str = "Ext.create('Ext.irm.DatatableSearchBox',{box:'#{search_box}',table:#{id}Datatable});"
    end

    export_str = "// Can not export data to excel"
    if options[:export_data].present?
      export_str = "Ext.create('Ext.irm.DatatableExport',{box:'#{options[:export_data]}',table:#{id}Datatable});"
    end

    script = %Q(

      // create the Data Store
      var #{id}DatatableStore = Ext.create('Ext.irm.DatatableStore', {
          pageSize: #{page_size},
          remoteSort: true,
          fields: [#{data_fields}],
          proxy: {
              type: 'jsonp',
              url: '#{source_url}',
              reader: {
                  root: 'items',
                  totalProperty: 'numRows'
              },
              // sends single sort as multi parameter
              simpleSortMode: true
          }
      });
      #{"var #{id}DatatableSelModel = new Ext.selection.CheckboxModel( {mode:'MULTI'});" if select&&select.eql?("multiple")}
      #{"var #{id}DatatableSelModel = new Ext.selection.CheckboxModel( {mode:'SINGLE'});" if select&&select.eql?("single")}
      #{"var #{id}DatatableSelModel = new Ext.selection.CheckboxModel( {mode:'SIMPLE'});" if select&&select.eql?("single")}

      var #{id}Datatable = Ext.create('Ext.grid.Panel', {
          id: '#{id}Datatable',
          height: #{height},
          store: #{id}DatatableStore,
          autoShow: true,
          disableSelection: false,
          loadMask: true,
          #{"selModel:#{id}DatatableSelModel," if select}
          selType: 'cellmodel',
          viewConfig: {
              trackOver: true,
              stripeRows: false,
              forceFit: true
          },
          // grid columns
          columns:[#{column_models}],
          // paging bar on the bottom
          bbar: Ext.create('Ext.PagingToolbar', {
              store: #{id}DatatableStore,
              displayInfo: true
          }),
          renderTo: '#{id}'
      });
    )

    grid_helper_script = load_str
    grid_helper_script << "\n"
    grid_helper_script << view_filter_str
    grid_helper_script << "\n"
    grid_helper_script << search_str
    grid_helper_script << export_str

    all_script = %Q(
      Ext.onReady(function(){
        #{script}
        #{grid_helper_script}
      });
    )

    javascript_tag(all_script)
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
      content_tag("div", raw(t(:error_invalid_data) + "<br>" + t(:check_error_msg_and_fix)), {:id => "errorDiv_ep", :class => "alert alert-error"})
    end
  end

  def flash_notice
    ret = ""
    ret = content_tag("div", raw(flash[:notice]), {:id => "succDiv_ep", :class => "alert alert-success"}) if flash[:notice].present?
    ret = content_tag("div", raw(flash[:error]), {:id => "errorDiv_ep", :class => "alert alert-error"}) if flash[:error].present?
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

  # 页面添加javascript文件，防止重复添加
  def require_javascript(name,param=nil)
    @loaded_javascript_files ||= {}

    if name.is_a?(String)||name.is_a?(Symbol)
      @loaded_javascript_files.merge!(name.to_sym=>param)
    elsif name.is_a?(Array)
      name.each do |file|
        @loaded_javascript_files.merge!(file.to_sym=>param)
      end
    end
  end


  # 页面添加css文件，防止重复添加
  def require_css(name,param=nil)
    @loaded_css_files ||= {}

    if name.is_a?(String)||name.is_a?(Symbol)
      @loaded_css_files.merge!(name.to_sym=>param)
    elsif name.is_a?(Array)
      name.each do |file|
        @loaded_css_files.merge!(file.to_sym=>param)
      end
    end
  end


  def render_loaded_javascript_css_files
    javascript_files = []
    css_files = []
    javascript_prefix = "/javascripts/"
    css_prefix ="/themes/#{theme_name}/stylesheets/"
    Ironmine::Application.config.fwk.javascript.source.each do |name,paths|
      if @loaded_javascript_files.keys.include?(name)
        paths.each do |path|
          if @loaded_javascript_files[name]
            javascript_files << path+@loaded_javascript_files[name]
          else
            javascript_files << path
          end
        end
      end
    end if @loaded_javascript_files

    Ironmine::Application.config.fwk.css.source.each do |name,paths|
      if @loaded_css_files.keys.include?(name)
        paths.each do |path|
          if @loaded_css_files[name]
            css_files << path+@loaded_css_files[name]
          else
            css_files << path
          end
        end
      end
    end if @loaded_css_files
    file_links = ""
    javascript_files.uniq!
    css_files.uniq!
    css_files.each do |css_file|
      if ie6?
        file_links<< tag("link", { "rel" => "stylesheet", "type" => Mime::CSS, "media" => "screen", "href" =>css_prefix+css_file+".ie6.css"}, false, false)
      else
        file_links<< tag("link", { "rel" => "stylesheet", "type" => Mime::CSS, "media" => "screen", "href" =>css_prefix+css_file+".css"}, false, false)
      end
    end
    javascript_files.each do |script_file|

      file_links<< content_tag("script", "", { "type" => Mime::JS, "src" =>javascript_prefix+script_file.gsub("{locale}",I18n.locale.to_s)+".js"})
    end

    raw file_links
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

  #文本编辑器
  def rich_text_area(textarea_id,force_fit_width=false)
    unless limit_device?
      require_javascript(:extjs)
      require_css(:extjs)
    end
    render :partial=>"helper/rich_text",:locals=>{:textarea_id=>textarea_id,:force_fit_width=>force_fit_width}
  end

  #xheditor编辑器
  def xheditor(textarea_id,force_fit_width=false)
    unless limit_device?
      require_jscss(:xheditor)
      render :partial=>"helper/xheditor",:locals=>{:textarea_id=>textarea_id,:force_fit_width=>force_fit_width}
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
