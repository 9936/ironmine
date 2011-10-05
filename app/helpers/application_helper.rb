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
  def yui_datatable(id,source_url,columns,options={})
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

    columns_conf  = "Ext.create('Ext.grid.RowNumberer'),"+ columns_conf  if options[:show_row_number]

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


  def datatable(id,url_options,columns,options={})

    select = options[:select]
    html = options[:html]||false

    if html&&limit_device?&&!select.present?
      return plain_datatable(id,url_options,columns,options={})
    else
      require_javascript(:extjs)
      require_css(:extjs)
    end

    source_url = url_for(url_options.merge(:format=>:json))
    page_size = options[:row_perpage]||10
    search_box = options[:search_box]




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
            elsif(value.include?("%"))
              column << %Q(width:#{value.gsub("%","")},)
           else
              column << %Q(width:#{value},)
            end
          #when :sortable
          #  column << %Q(sortable:false,)
          when :formatter
            if value.eql?("Y.irm.template")
              column << %Q(renderer: Ext.irm.dtTemplate,)
            elsif value.eql?("Y.irm.stemplate")
              column << %Q(renderer: Ext.irm.dtScriptTemplate,)
            end
          when :searchable
            column << %Q(searchable:#{value},)
          when :locked
            column << %Q(locked:#{value},)
        end


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
      view_filter_str = "Ext.create('Ext.irm.ViewFilter',{filter:'#{id}ViewFilterOverview',table:#{id}Datatable})"
      load_str = "//does not load #{id}Datatable data,because of view filter #{options[:view_filter]}"
    end

    search_str = "// Now Search Box for #{id}Datatable"
    if search_box
      search_str = "Ext.create('Ext.irm.DatatableSearchBox',{box:'#{search_box}',table:#{id}Datatable})"
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
          height: 250,
          store: #{id}DatatableStore,
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

    all_script = %Q(
      Ext.onReady(function(){
        #{script}
        #{grid_helper_script}
      });
    )

    javascript_tag(all_script)
  end



  def plain_datatable(id,url_options,columns,options={})
    require_javascript(:jplugin)

    source_url = url_for(url_options.merge(:format=>:html))

    page_size = options[:row_perpage]||10

    search_box = options[:search_box]

    table_options = "baseUrl:'#{source_url}',pageSize:#{page_size},searchBox:'#{search_box}'"


    if options[:view_filter]
      table_options << "filterBox:'#{id}ViewFilterOverview'"
    end

    table_options = "{#{table_options}}"
    script = %Q(
        $(function(){$('##{id}').datatable(#{table_options})});
    )
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
    time.strftime('%Y-%m-%d %H:%M:%S') if time
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
    env =
    javascript_files = []
    css_files = []
    javascript_prefix = "/javascripts/"
    css_prefix ="/themes/#{theme_name}/stylesheets/"
    Ironmine::Application.config.ironmine.javascript.source.each do |name,paths|
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

    Ironmine::Application.config.ironmine.css.source.each do |name,paths|
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

  # 判断浏览器是否为ie6
  def ie6?
    request.user_agent.include?("MSIE 6.0")
  end

  # 将使用IE6和Android 2的设备设置为限制设备
  def limit_device?
    request.user_agent.include?("MSIE 6.0") || request.user_agent.include?("Android 2") || request.user_agent.include?("iPad")||request.user_agent.include?("iPhone")
  end

  #文本编辑器
  def rich_text_area(textarea_id,force_fit_width=false)
    unless limit_device?
      require_javascript(:extjs)
      require_css(:extjs)
    end
    render :partial=>"helper/rich_text",:locals=>{:textarea_id=>textarea_id,:force_fit_width=>force_fit_width}
  end
end
