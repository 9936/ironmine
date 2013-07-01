module FormHelper
  def text_field_tag(name, value = nil, options = {})
    content = tag :input, { "type" => "text", "name" => name, "id" => sanitize_to_id(name), "value" => value }.update(options.stringify_keys)

    if options[:required]&&!options[:normal]
      wrapped_field(content, options)
    else
      content
    end
  end

  def input_file_tag(name, options = {})
    if limit_device? || options.delete(:normal)
      file_field_tag(name, options )
    else
      file_input = file_field_tag(name, options.merge(:normal => true, :class => "file-input", :onchange => %Q($('#input-file-name-#{sanitize_to_id(name)}').val($(this).val());)))
      file_input_value = text_field_tag("input-file-name-#{name}", nil, :class => "input-file-value", :normal => true)
      file_input_btn = link_to("#{t(:browse)}...",{},{:href=>"javascript:void(0);", :class => "btn input-file-btn"})
      file_upload_box = content_tag(:div,file_input+file_input_value+file_input_btn, :class => "file-upload-box")
      wrapped_field(content_tag(:div, file_upload_box,{:class => "input-append"}, false),options)
    end
  end


  def text_area_tag(name, content = nil, options = {})
    options.stringify_keys!

    if size = options.delete("size")
      options["cols"], options["rows"] = size.split("x") if size.respond_to?(:split)
    end

    escape = options.key?("escape") ? options.delete("escape") : true
    content = ERB::Util.html_escape(content) if escape

    real_content = content_tag :textarea, content.to_s.html_safe, { "name" => name, "id" => sanitize_to_id(name) }.update(options)
    if options[:required]&&!options[:normal]
      wrapped_field(real_content, options)
    else
      real_content
    end
  end

  def blank_lookup_field_tag(name,lookup_type,selected=nil, options ={})
    values =  available_lookup_type(lookup_type)
    blank_select_tag(name,values,selected,options)
  end

  def lookup_field_tag(name,lookup_type,selected=nil, options ={})
    values =  available_lookup_type(lookup_type)
    select_tag_alias(name,values,selected,options)
  end

  def date_field_tag(field, options = {})
    field_id =  options.delete(:id)||field
    datetime = Time.now
    date_text = datetime.strftime('%Y-%m-%d')
    if options.delete(:with_time)
      if options[:value].present?
        begin
          init_datetime = Time.parse("#{options[:value]}")
          init_date = init_datetime.strftime('%Y-%m-%d')
          init_time = init_datetime.strftime('%H:%M:%S')
        rescue
          init_date = nil, init_time = nil
        end
      else
        init_date = nil, init_time = nil
      end
      date_field_id = "#{field_id}_date"
      time_field_id = "#{field_id}_time"
      #需要设置一个隐藏的input保留值
      date_time_tag =  hidden_field_tag(field,options[:value],options.merge(:id=>field_id))
      date_tag_str = text_field_tag(date_field_id, init_date, :size=>10,:class=>"date-input",:id => date_field_id,:onfocus=>"initDateField(this)",:autocomplete => "off",:normal=>true)
      link_text  = datetime.strftime('%Y-%m-%d %H:%M:%S')
      time_text = datetime.strftime('%H:%M:%S')
      time_tag_str = text_field_tag(time_field_id,init_time,:class => "timepicker", :id => time_field_id, :style => "width:75px;",:autocomplete => "off",:normal=>true)
      script = %Q(
         $(document).ready(function () {
            initDateTime("#{time_field_id}", "#{date_field_id}", "#{field_id}", "#{init_time}");
         });
      )
      link_click_action = %Q(javascript:dateFieldChooseToday('#{date_field_id}','#{date_text}','#{time_field_id}','#{time_text}'))
      content = date_time_tag + date_tag_str + raw("&nbsp;-&nbsp;")+ time_tag_str
      content += javascript_tag(script)
    else
      link_text  = Time.now.strftime('%Y-%m-%d')
      date_tag_str = text_field_tag(field,options[:value],options.merge(:id=>field_id,:class=>"date-input",:size=>10,:onfocus=>"initDateField(this)",:normal=>true))
      content = date_tag_str
      link_click_action = %Q(javascript:dateFieldChooseToday('#{field_id}','#{link_text}'))
    end
    link_str = ""
    link_str = link_to(" [#{link_text}]",{},{:href=>link_click_action}) unless options[:nobutton]
    content += link_str
    wrapped_field(content_tag(:div,content,{:class=>"date-field"},false),options)
  end

  def color_field_tag(field, options = {})
    color_field_id =  options.delete(:id)||field

    color_tag_str = text_field_tag(field,options[:value],options.merge(:id=>color_field_id,:class=>"color-input",:size=>10,:onfocus=>"initColorField(this)",:normal=>true,:style=>"background-color:#{options[:value]};color:#{get_contrast_yiq(options[:value])};","data-color"=>options[:value],"data-color-format"=>"hex"))

    wrapped_field(content_tag(:div,color_tag_str,{:class=>"color-field"},false),options)
  end


  private


  # Returns a label tag for the given field
  def wrapped_field(field, options = {})
    required_flag = options.delete(:required) ? true : false
    text = ""

    field_text = content_tag("span", field,{:class => "form-field"}, false)

    required_text = content_tag("span","",{:class => "form-field-required-flag"}, false)

    info_image = ""

    if options.delete(:info)
      info_text = content_tag(:img, "", :src => "/images/s.gif", :class => "form-field-info", :title => info_t, :alt => info_t)
      info_image = content_tag(:span, info_text,false)
    end

    error_message_text =   error_message(options.delete(:error))

    field_class = ["form-field-wrapped"]
    field_class << "form-field-required" if required_flag
    field_class << "form-field-error" if error_message_text.present?

    content_tag("div", required_text+field_text + info_image + error_message_text,{:class => field_class.join(" ")}, false)

  end

  def error_message(error_msg)
    if error_msg.present?
      return "<span class=\"error-message\"><strong>#{I18n.t(:error)}:</strong>#{error_msg}</span>".html_safe
    end
  end

  #定义timetrigger_tag
  def time_trigger(form)
    time_trigger = Irm::TimeTrigger.query_target(form.object.id, form.object.class.name).first if form.object.id.present?
    time_trigger ||= Irm::TimeTrigger.new

    time_trigger_object_name = "#{form.object_name}[time_trigger]"

    fields_for "#{time_trigger_object_name}", time_trigger, :builder => CustomFormBuilder do |builder|
      render :partial => "irm/common/time_trigger", :locals => {:f => builder, :object_name => time_trigger_object_name}
    end

  end
end