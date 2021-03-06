module Irm::ListOfValuesHelper
  def lov_field_tag(name,lov_code,options={})
    lov_field_id =  options.delete(:id)||name
    relation_submit = options.delete(:relation_submit) || false

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

    lov_params = options.delete(:lov_params)
    custom_params = options.delete(:custom_params)

    hidden_tag_str = hidden_field_tag(name,value,{:name=>options.delete(:name)||name,:id=>lov_field_id,:href=>url_for({:controller => "irm/list_of_values",:action=>"lov",:lkfid=>lov_field_id,:lkvfid=>lov_value_field,:lktp=>bo.id}.merge(:lov_params=>lov_params))})
    label_tag_str = text_field_tag("#{name.to_s.gsub("[","_").gsub("]","")}_label",label_value,options.merge(:id=>"#{lov_field_id}_label",:onchange=>"clearLookup('#{lov_field_id}')"))

    lov_controller_action = {:controller => "irm/list_of_values",:action=>"lov"}
    lov_result_controller_action = {:controller => "irm/list_of_values",:action=>"lov_result"}
    if custom_params
      if custom_params[:lov].present?
        lov_controller_action = custom_params[:lov]
      end

      if custom_params[:lov_result]
        lov_result_controller_action = custom_params[:lov_result]
      end
    end


    onblur_script = %Q(
      $(document).ready(function(){
         var relation_submit = "#{relation_submit}",
             url = '#{url_for(lov_result_controller_action.merge({:lkfid=>lov_field_id,:lkvfid=>lov_value_field,:lktp=>bo.id}).merge(:lov_params=>lov_params))}',
             lov_field_id = "#{lov_field_id}";
         checkLovResult(url,lov_field_id,relation_submit);
      });
    )



    link_click_action = %Q(javascript:openLookup('#{url_for(lov_controller_action.merge({:lkfid=>lov_field_id,:lkvfid=>lov_value_field,:lktp=>bo.id}).merge(:lov_params=>lov_params))}'+'&lcps=#{custom_params}&lksrch='+$('##{lov_field_id}_label').val(),670))

    if limit_device?
      lov_link_str = link_to({},{:id => "#{lov_field_id}_btn",:class=>"btn lov-btn add-on",:href=>link_click_action,:onclick=>"setLastMousePosition(event)"}) do
        lov_text.html_safe
      end
    else
      lov_link_str = link_to({},{:id => "#{lov_field_id}_btn",:class=>"btn lov-btn",:href=>link_click_action,:onclick=>"setLastMousePosition(event)"}) do
        content_tag(:i,"",{:class=>"icon-search"}).html_safe
      end
    end
    tooltip = content_tag(:div,t(:lov_tooltip_text),{:id => "#{lov_field_id}Tip",:class => "alert fade in",:style => "z-index:99;position:absolute;display:none;padding:5px;text-align:left; ","tooltip-text" => t(:lov_tooltip_text), "tooltip-error-text" => t(:lov_error_tooltip_text)})

    content_tag(:div,hidden_tag_str+label_tag_str+lov_link_str+javascript_tag(onblur_script)+tooltip,{:id => "#{lov_field_id}Box",:class=>"form-inline input-append",:style => "zoom:1"},false)

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

  def handler_lov_data(data)
    if data
      if data.is_a?(Time)
        data = data.strftime('%Y-%m-%d %H:%M:%S')
      elsif data.is_a?(Date)
        data = data.strftime('%Y-%m-%d')
      end
    end
    data
  end

  #分页显示记录
  def lov_paginate(total=0, page = 1, per_page = 10, limit_page = 10)
    #总的页码
    total_page = total % per_page == 0? total/per_page : total/per_page + 1
    page_html = '<div class="pagination" style="float: right;"><ul>'

    if total_page >= page and page > 0 and total_page > 1
      #计算显示的开始页码和结尾页码
      start_page = page - (limit_page % 2 == 0? limit_page/2 - 1 : limit_page/2)
      end_page = page + limit_page/2
      if start_page < 1
        start_page = 1
        if total_page > limit_page
          end_page = limit_page
        else
          end_page = total_page
        end
      end
      if end_page > total_page
        end_page = total_page
        if (end_page - limit_page) > 0
          start_page = end_page - limit_page + 1
        else
          start_page = 1
        end
      end
      #显示前一页
      if page > 1
        page_html += "<li>"
        page_html += link_to t(:label_search_previous_page), "javascript:void(0);", :page => page - 1
        page_html += "</li>"
      end
      #显示中间页码
      (start_page..end_page).each do |i|
        if i.to_i.eql?(page.to_i)
          page_html += '<li class="disabled">'
          page_html += link_to i.to_s, "javascript:void(0);", :page => i
        else
          page_html += '<li>'
          page_html += link_to i.to_s, "javascript:void(0);", :page => i
        end
        page_html += "</li>"
      end
      #显示下一页
      if page < total_page
        page_html += link_to t(:label_search_next_page), "javascript:void(0);", :page => page + 1
      end
    end
    page_html += " </ul></div>"
    page_html.html_safe
  end



end
