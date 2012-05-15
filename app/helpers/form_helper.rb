module FormHelper
  def text_field_tag(name, value = nil, options = {})
    content = tag :input, { "type" => "text", "name" => name, "id" => sanitize_to_id(name), "value" => value }.update(options.stringify_keys)

    if options[:required]&&!options[:normal]
      wrapped_field(content, options)
    else
      content
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

  def date_field_tag(field, options = {})
    date_field_id =  options.delete(:id)||field

    link_text  = Time.now.strftime('%Y-%m-%d')

    date_tag_str = text_field_tag(field,options[:value],options.merge(:id=>date_field_id,:class=>"date-input",:size=>10,:onfocus=>"initDateField(this)",:normal=>true))

    link_click_action = %Q(javascript:dateFieldChooseToday('#{date_field_id}','#{link_text}'))

    link_str = ""

    link_str = link_to("[#{link_text}]",{},{:href=>link_click_action}) unless options[:no_button]

    wrapped_field(content_tag(:div,date_tag_str+link_str,{:class=>"date-field"},false),options)
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
end