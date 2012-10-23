class CustomFormBuilder  < ActionView::Helpers::FormBuilder
  # 自定义 form 控件的生成方式
  (field_helpers - %w(radio_button hidden_field) + %w(date_select)).each do |selector|
    src = <<-END_SRC
    def #{selector}(field, options = {})
      if options.delete(:normal)
          super
      else
        if options.delete(:required)
          wrapped_field(super(field,options.merge({:irequired=>true})),field, options.merge({:required=>true}))
        else
          wrapped_field(super,field,options)
        end
      end
    end
    END_SRC
    class_eval src, __FILE__, __LINE__
  end


  def select(field, choices, options = {}, html_options = {})
    if options.delete(:normal)
      super
    else
      if html_options[:required]||options[:required]
        options.merge!({:required=>true})
        wrapped_field(super(field,choices,options,html_options),field, options)
      else
        wrapped_field(super,field,options)
      end
    end
  end


  def blank_select(field, choices, options = {}, html_options = {})
    options=(options||{}).merge({:include_blank=>"--- #{I18n.t(:actionview_instancetag_blank_option)} ---"})
    html_options =(html_options||{}).merge(:blank=> "--- #{I18n.t(:actionview_instancetag_blank_option)} ---")
    select(field, choices, options, html_options)
  end


  def lov_field(field, lov_code, options = {}, html_options = {})
    lov_field_id =  options.delete(:id)||field
    bo = nil

    # 使用业务对像的id作为lov_code
    if options.delete(:id_type)
      bo = Irm::BusinessObject.find(lov_code)
    else
      lov_type = lov_code
      if lov_type.is_a?(Class)&&(lov_type.respond_to?(:name))
        lov_type = lov_type.name
      end
      bo = Irm::BusinessObject.where(:bo_model_name=>lov_type).first
    end

    # lov 返回的值字段
    lov_value_field = options.delete(:value_field)||"id"

    # lov 的值
    value = object.send(field.to_sym)

    # lov的显示值
    label_value = options.delete(:label_value)

    # 补全显示值
    if value.present?&&!label_value.present?
      value,label_value = bo.lookup_label_value(value,lov_value_field)
    end

    # 补全值
    if !value.present?&&label_value.present?
      value,label_value = bo.lookup_value(label_value,lov_value_field)
    end

    unless value.present?&&label_value.present?
      value,label_value = "",""
    end

    hidden_tag_str = hidden_field(field,{:id=>lov_field_id,:href=>@template.url_for(:controller => "irm/list_of_values",:action=>"lov",:lkfid=>lov_field_id,:lkvfid=>lov_value_field,:lktp=>bo.id)})
    label_tag_str = @template.text_field_tag("#{field}_label",label_value,options.merge(:id=>"#{lov_field_id}_label",:onchange=>"clearLookup('#{lov_field_id}')",:normal=>true))

    link_click_action = %Q(javascript:openLookup('#{@template.url_for(:controller => "irm/list_of_values",:action=>"lov",:lkfid=>lov_field_id,:lkvfid=>lov_value_field,:lktp=>bo.id)}'+'&lksrch='+$('##{lov_field_id}_label').val(),670))

    if @template.limit_device?
      lov_link_str = @template.link_to({},{:class=>"btn lov-btn add-on",:href=>link_click_action,:onclick=>"setLastMousePosition(event)"}) do
        @template.lov_text.html_safe
      end
    else
      lov_link_str = @template.link_to({},{:class=>"btn lov-btn",:href=>link_click_action,:onclick=>"setLastMousePosition(event)"}) do
        @template.content_tag(:i,"",{:class=>"icon-search"}).html_safe
      end
    end
    wrapped_field(@template.content_tag(:div,hidden_tag_str+label_tag_str+lov_link_str,{:class=>"from-inline input-append"},false),field,options)

  end

  #封装lookup_value标签
  def lookup_field(field, lookup_type, options={}, html_options = {})
    values =  @template.available_lookup_type(lookup_type)
    select(field, values, options, html_options)
  end

  def blank_lookup_field(field, lookup_type, options={}, html_options = {})
    values =  @template.available_lookup_type(lookup_type)
    blank_select(field, values, options, html_options)
  end






  def check_box(method, options = {}, checked_value = "Y", unchecked_value = "N")
    if !options.delete(:normal)
      return @template.check_box(@object_name, method, objectify_options(options), checked_value, unchecked_value)
    else
      return label_for_field(method, options) +@template.check_box(@object_name, method, objectify_options(options), checked_value, unchecked_value)
    end
  end


  def date_field(field, options = {})
    method = field
    field_id =  options.delete(:id)|| field
    datetime = Time.now
    date_text = datetime.strftime('%Y-%m-%d')
    if options.delete(:with_time)
      @object || @template_object.instance_variable_get("@#{@object_name}")
      if @object.send(method).to_s.capitalize
        init_datetime = Time.parse("#{@object.send(method).to_s.capitalize}")
        init_date = init_datetime.strftime('%Y-%m-%d')
        init_time = init_datetime.strftime('%H:%M:%S')
      else
        init_date = init_time = nil
      end

      date_field_id = "#{field_id}_date"
      time_field_id = "#{field_id}_time"
      #需要设置一个隐藏的input保留值
      date_time_tag =  self.hidden_field(field,options.merge(:id=>field_id))
      date_tag_str = @template.text_field_tag(date_field_id, init_date, :size=>10,:class=>"date-input",:onfocus=>"initDateField(this)",:autocomplete => "off")
      link_text  = datetime.strftime('%Y-%m-%d %H:%M:%S')
      time_text = datetime.strftime('%H:%M:%S')
      time_tag_str = @template.text_field_tag(time_field_id,init_time,:class => "timepicker", :id => time_field_id, :style => "width:75px;",:autocomplete => "off")
      script = %Q(
         $(document).ready(function () {
            $('##{time_field_id}').timepicker({
                minuteStep: 5,
                showSeconds: true,
                secondStep: 10,
                showMeridian: false,
                showInputs: true,
                disableFocus: false
            });
            var date_time = $("##{field_id}").val();
            $("##{time_field_id}").bind('change',function(){
                if($("##{date_field_id}").val()){
                    date_time = $("##{date_field_id}").val() +" " + $(this).val();
                    $("##{field_id}").val(date_time);
                }else{
                    $("##{field_id}").val('');
                }
            });
            $("##{date_field_id}").bind('blur',function(){
                if($(this).val()){
                    date_time = $(this).val() + " " + $("##{time_field_id}").val();
                    $("##{field_id}").val(date_time);
                }else{
                    $("##{field_id}").val('');
                }
            });
         });
      )
      link_click_action = %Q(javascript:dateFieldChooseToday('#{date_field_id}','#{date_text}','#{time_field_id}','#{time_text}'))
      content = date_time_tag + date_tag_str +@template.raw("&nbsp;-&nbsp;")+ time_tag_str
      content += @template.javascript_tag(script)
    else
      date_tag_str = self.text_field(field,options.merge(:id=>field_id,:size=>10,:class=>"date-input",:onfocus=>"initDateField(this)",:normal=>true,:autocomplete => "off"))
      link_text  = datetime.strftime('%Y-%m-%d')
      content = date_tag_str
      link_click_action = %Q(javascript:dateFieldChooseToday('#{field_id}','#{date_text}'))
    end
    link_str = ""
    link_str = @template.link_to("[#{link_text}]",{},{:href=>link_click_action}) unless options[:nobutton]
    content += link_str
    wrapped_field(@template.content_tag(:div,content,{:class=>"date-field"},false),field,options)
  end


  def color_field(field, options = {})
    color_field_id =  options.delete(:id)||field

    value = object.send(field.to_sym) ||options[:value]

    color_tag_str = self.text_field(field,options.merge(:id=>color_field_id,:class=>"color-input",:size=>10,:onfocus=>"initColorField(this)",:normal=>true,:style=>"background-color:#{value};color:#{@template.get_contrast_yiq(value)};","data-color"=>value,"data-color-format"=>"hex"))

    wrapped_field(@template.content_tag(:div,color_tag_str,{:class=>"color-field"},false),field,options)
  end


  def file_field(field, options = {})
    file_field_id = options.delete(:id)||field
    if @template.limit_device? || options.delete(:normal)
      super(field, options)
    else
      file_input = super(field, options.merge(:id => file_field_id, :class => "file-input", :onchange => %Q($('#input-file-name-#{field}').val($(this).val());)))
      file_input_value = @template.text_field_tag("input-file-name-#{field}", nil, :class => "input-file-value")
      file_input_btn = @template.link_to("#{I18n.t(:browse)}...",{},{:href=>"javascript:void(0);", :class => "btn input-file-btn"})
      file_upload_box = @template.content_tag(:div,file_input+file_input_value+file_input_btn, :class => "file-upload-box")
      wrapped_field(@template.content_tag(:div, file_upload_box,{:class => "input-append"}, false),field, options)
    end
  end

  # Returns a label tag for the given field
  def wrapped_field(field,field_id, options = {})
    required_flag = options.delete(:required) ? true : false
    full_flag = options.delete(:full) ? true : false
    text = ""

    field_text = @template.content_tag("span", field,{:class => "form-field"}, false)

    required_text = @template.content_tag("span","",{:class => "form-field-required-flag"}, false)

    info_image = ""

    if options.delete(:info)
      info_text = @template.content_tag(:img, "", :src => "/images/s.gif", :class => "form-field-info", :title => info_t, :alt => info_t)
      info_image = @template.content_tag(:span, info_text,false)
    end

    error_message_text = error_message(object,field_id)

    field_class = ["form-field-wrapped"]
    field_class << "form-field-required" if required_flag
    field_class << "form-field-full" if full_flag
    field_class << "form-field-error" if error_message_text.present?

    @template.content_tag("div", required_text+field_text + info_image + error_message_text,{:class => field_class.join(" ")}, false)

  end

  private

  def error_message(object,field)
    if object.errors[field.to_sym].present?
      return "<span class=\"error-message\"><strong>#{I18n.t(:error)}:</strong>#{object.errors[field.to_sym]}</span>".html_safe
    end
  end


end