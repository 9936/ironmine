module Irm::ListOfValuesHelper
  def lov_field_tag(name,lov_code,options={})
    lov_field_id =  options.delete(:id)||name

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
    value = options.delete(:value)

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

    hidden_tag_str = hidden_field_tag(name,value,{:name=>options.delete(:name)||name,:id=>lov_field_id,:href=>url_for(:controller => "irm/list_of_values",:action=>"lov",:lkfid=>lov_field_id,:lkvfid=>lov_value_field,:lktp=>bo.id)})
    label_tag_str = text_field_tag("#{name.to_s.gsub("[","_").gsub("]","")}_label",label_value,options.merge(:id=>"#{lov_field_id}_label",:onchange=>"clearLookup('#{lov_field_id}')"))

    link_click_action = %Q(javascript:openLookup('#{url_for(:controller => "irm/list_of_values",:action=>"lov",:lkfid=>lov_field_id,:lkvfid=>lov_value_field,:lktp=>bo.id)}'+'&lksrch='+$('##{lov_field_id}_label').val(),670))

    lov_link_str = link_to({},{:class=>"btn lov-btn",:href=>link_click_action,:onclick=>"setLastMousePosition(event)"}) do
      content_tag(:i,"",{:class=>"icon-search"}).html_safe
    end
    content_tag(:div,hidden_tag_str+label_tag_str+lov_link_str,{:class=>"input-append"},false)

  end

  private
  def lov_as_select(name,lov,options)
    values = []
    values = eval(lov.generate_scope).collect{|v| [v[:show_value],v[:id_value],v.attributes]} if lov
    selected_value = options.delete(:value)
    blank_select_tag(name,values,selected_value,options)
  end

  def lov_as_autocomplete(name,lov,options)
    input_node_id =  options.delete(:id)||name
    value = options.delete(:value)
    label_value = options.delete(:label_value)
    hidden_tag_str = hidden_field_tag(name,value,{:id=>input_node_id})
    if value.present?
      if options.delete(:label_required)
        label_value = lov.lov_value(value)
      else
        label_value = value
      end
    end
    label_tag_str = text_field_tag("#{name}Label",label_value,options.merge(:id=>"#{input_node_id}Label"))

    columns = []
    columns <<{:key=>"id_value",:hidden=>true,:return_to=>"##{input_node_id}"}
    columns <<{:key=>"show_value",:label=>lov[:value_title],:width=>lov.value_column_width}
    columns <<{:key=>"desc_value",:label=>lov[:desc_title],:width=>lov.desc_column_width} if lov.desc_column.present?

    unless lov.addition_column.nil? || lov.addition_column.strip.blank?
      acs =   lov.addition_column.split("#")
      acws = lov.addition_column_width.split("#")
      acts = lov[:addition_title].split("#")
    end
    acs.each_with_index do |column,index|
      columns <<{:key=>column,:label=>acts[index],:width=>acws[index]}
    end if acs

    script = autocomplete("#{input_node_id}Label",url_for(:controller=>"irm/list_of_values",:action=>"get_lov_data",:id=>lov.id),columns)
    (hidden_tag_str+label_tag_str+script).html_safe
  end


  def lookup_pick_link(field_id,value,label,data)
    link_to(label,{},{:href=>"javascript:top.window.opener.lookupPick('#{field_id}','#{value}','#{label}',#{data.to_json})"})
  end

end
