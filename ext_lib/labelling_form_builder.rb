class LabellingFormBuilder  < ActionView::Helpers::FormBuilder
  # 自动生成label
  (field_helpers - %w(radio_button hidden_field) + %w(date_select)).each do |selector|
    src = <<-END_SRC
    def #{selector}(field, options = {})
      if options.delete(:normal)
        if options[:required]
          super(field,options.merge!({:required=>true}))
        else
          super
        end
      else
        if options[:required]
          label_for_field(super(field,options.merge!({:required=>true})), options)
        else
          super
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
      if html_options[:required]
        label_for_field(super(field,choices, options, html_options.merge!({:required=>true})), html_options)
      else
        super
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
      label_value = bo.lookup_label_value(value,lov_value_field)
    end

    # 补全值
    if !value.present?&&label_value.present?
      value,label_value = bo.lookup_value(label_value,lov_value_field)
    end

    hidden_tag_str = hidden_field(field,{:id=>lov_field_id})
    label_tag_str = @template.text_field_tag("#{field}_label",label_value,options.merge(:id=>"#{lov_field_id}_label",:onchange=>"clearLookup('#{lov_field_id}')"))

    link_click_action = %Q(javascript:openLookup('#{@template.url_for(:controller => "irm/list_of_values",:action=>"lov",:lkfid=>lov_field_id,:lkvfid=>lov_value_field,:lktp=>bo.id)}'+'&lksrch='+$('##{lov_field_id}_label').val(),670))

    lov_link_str = @template.link_to({},{:href=>link_click_action,:onclick=>"setLastMousePosition(event)"}) do
      @template.content_tag(:img,"",{:src=>@template.theme_image_path("s.gif"),:class=>"lookupIcon",:onblur=>"this.className = 'lookupIcon';",:onfocus=>"this.className = 'lookupIconOn';",:onmouseout=>"this.className = 'lookupIcon';",:onmouseover=>"this.className = 'lookupIconOn';"}).html_safe
    end
    @template.content_tag(:div,(hidden_tag_str+label_tag_str+lov_link_str+error_message(object,field)).html_safe ,:style=>"display:inline")

  end



  
  def check_box(method, options = {}, checked_value = "Y", unchecked_value = "N")
    if !options.delete(:normal)
      return @template.check_box(@object_name, method, objectify_options(options), checked_value, unchecked_value)
    else
      return label_for_field(method, options) +@template.check_box(@object_name, method, objectify_options(options), checked_value, unchecked_value)
    end
  end
  
  # Returns a label tag for the given field
  def label_for_field(field, options = {})
      text = ""
      text += @template.content_tag("div", "", :class => "requiredBlock") if options.delete(:required)
      info = ""
      if options[:info]
        info_t = options.delete(:info)

        if info_t
          info += @template.content_tag(:img, "", :src => "/images/s.gif", :class => "infoIcon", :title => info_t, :alt => info_t)
        end
      end
      @template.content_tag("div", text + field + info,{:class => "requiredInput"}, false)


#      text = options[:label].is_a?(Symbol) ? ::I18n.t(options[:label]) : options[:label]
#      text ||= ::I18n.t(("label_#{@object_name.to_s}_" + field.to_s.gsub(/\_id$/, "")).to_sym)
#      text += @template.content_tag("span", " *", :class => "required") if options.delete(:required)
#      @template.content_tag("label", text,
#                                    {:class => (@object && @object.errors[field] ? "error" : nil),
#                                     :for => (@object_name.to_s + "_" + field.to_s)},false)
  end

  private

  def error_message(object,field)
    if object.errors[field.to_sym].present?
      return "<div class=\"errorMsg\"><strong>#{I18n.t(:error)}:</strong>#{object.errors[field.to_sym]}</div>".html_safe
    end
  end

  def lov_as_select(field,lov,options,html_options)
    # TODO cascade select
    values = []
    values = eval(lov.generate_scope).collect{|v| [v[:show_value],v[:id_value],v.attributes]}
    blank_select(field,values,options,html_options)
  end

  def lov_as_autocomplete(field,lov,options,html_options)
    input_node_id =  options.delete(:id)||field
    value = object.send(field.to_sym)
    label_value = options.delete(:label_value)
    if value.present?&&!label_value.present?
      if options.delete(:label_required)
        label_value = lov.lov_value(value)
      else
        label_value = value
      end
    end
    hidden_tag_str = text_field(field,options.merge({:style=>"display:none;",:id=>input_node_id}))
    label_tag_str = @template.text_field_tag("#{input_node_id}Label",label_value,options.merge(:id=>"#{input_node_id}Label"))

    columns = []
    columns <<{:key=>"id_value",:hidden=>true,:return_to=>"##{input_node_id}"}
    columns <<{:key=>"show_value",:label=>lov[:value_title],:width=>lov.value_column_width}
    columns <<{:key=>"desc_value",:label=>lov[:desc_title],:width=>lov.desc_column_width} if lov.desc_column.present?

    unless lov.addition_column.strip.blank?||lov.addition_column.nil?
      acs =   lov.addition_column.split("#")
      acws = lov.addition_column_width.split("#")
      acts = lov[:addition_title].split("#")
    end
    acs.each_with_index do |column,index|
      columns <<{:key=>columns,:label=>acts[index],:width=>acws[index]}
    end if acs

    script = @template.autocomplete("#{input_node_id}Label",@template.url_for(:controller=>"irm/list_of_values",:action=>"get_lov_data",:id=>lov.id),columns)
    (hidden_tag_str+label_tag_str+script).html_safe
  end

  
end