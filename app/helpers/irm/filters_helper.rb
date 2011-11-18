# -*- coding: utf-8 -*-
module Irm::FiltersHelper
  def filter_bo(bo_code)
    Irm::BusinessObject.where(:business_object_code=>bo_code).first
  end

  def filter_data_range_all_label(bo)
    t("label_"+bo.bo_model_name.underscore.gsub("/","_")+"_view_filter_data_range_all",:default=>:label_irm_view_filter_data_range_all)+Irm::BusinessObject.class_name_to_meaning(bo.bo_model_name)
  end

  def filter_data_range_main_label(bo)
    t("label_"+bo.bo_model_name.underscore.gsub("/","_")+"_view_filter_data_range_main",:default=>:label_irm_view_filter_data_range_main)+Irm::BusinessObject.class_name_to_meaning(bo.bo_model_name)
  end

  def available_view_column(source_code)
    view_filter_columns(source_code)
  end

  def available_view_operator
    view_filter_operators("common")
  end
  # 在原来options加入请选择
  def nullable_collection_options(collection,key,meaning,current_value)
    nulloptions = content_tag(:option,"--- #{t(:actionview_instancetag_blank_option)} ---",{:value=>""})
    nulloptions.safe_concat(options_from_collection_for_select(collection,key,meaning,current_value))
  end
  # 在原来options加入请选择
  def nullable_options_for_select(collection,current_value)
    nulloptions = content_tag(:option,"--- #{t(:actionview_instancetag_blank_option)} ---",{:value=>""})
    nulloptions.safe_concat(options_for_select(collection,current_value))
  end



  def view_filter(source_code,bo_code,datatable_id)
    render :partial=>"irm/filters/view_filter",:locals=>{:source_code=>source_code,:bo_code=>bo_code,:datatable_id=>datatable_id}
  end


  def available_view_filter(source_code)
    filters = view_filters(source_code)
    current = filters.detect{|f| f.id.to_s.eql?(session[:_view_filter_id].to_s)}
    # 取得我的默认选项
    current = filters.detect{|f| f.default_flag.eql?(Irm::Constant::SYS_YES)&&f.own_id.eql?(Irm::Person.current.id)} unless current
    # 如果我的默认选项不存在，则使用全局默认选项
    current = filters.detect{|f| f.default_flag.eql?(Irm::Constant::SYS_YES)} unless current
    current ||= {:id=>nil}
    options_from_collection_for_select(filters,:id,:filter_name,current[:id])
  end

  def back_url
    url_for(params)
  end

  def render_exists_operator_and_value(bo_code,object_attribute_name,form)
    oa = Irm::ObjectAttribute.query_by_business_object_code(bo_code).where(:attribute_name=>object_attribute_name).first
    render_operator_and_value(oa,form)
  end

  def render_operator_and_value(object_attribute,form)
    return render_nil_object_attribute(form) unless object_attribute
    data_type = object_attribute.data_type
    relation_bo_id = object_attribute.relation_bo_id
    operators = view_filter_operators(object_attribute.data_type,relation_bo_id.present?)

    operator_tag = form.select(:operator_code,operators, {:required=>true},{:style=>"min-width:150px"})
    operator_tag = content_tag(:div,operator_tag,{:style=>"display:inline; padding-right: 10px;"},false)

    value_tag = ""

    if relation_bo_id.present?
      relation_object_attribute = Irm::ObjectAttribute.find(object_attribute.relation_object_attribute_id)
      value_tag = form.lov_field(:filter_value,relation_bo_id,{:id=>"filter_value_#{form.object.seq_num}_#{Irm::IdGenerator.instance.generate("irm_rule_filters")}",:value_field=>relation_object_attribute.attribute_name,:id_type=>true})
    else
      value_tag = form.text_field :filter_value,:size=>30
    end
    value_tag = content_tag(:div,value_tag,{:style=>"display:inline;"},false)
    (operator_tag + value_tag).html_safe
  end

  private
  def view_filter_columns(bo_code)
    Irm::ObjectAttribute.selectable_column.query_by_status_code("ENABLED").multilingual.filterable.query_by_business_object_code(bo_code).collect{|i|[i[:name],i.attribute_name,{:attribute_id=>i.id}]}
  end

  def view_filters(source_code)
    Irm::RuleFilter.hold.query_by_source_code(source_code)
  end

  def view_filter_operators(data_type,lov_flag=false)
    operators = Irm::LookupValue.query_by_lookup_type("RULE_FILTER_OPERATOR").multilingual.order_id
    available_ops = (Irm::RuleFilterCriterion::OPERATORS[data_type.to_sym]+Irm::RuleFilterCriterion::OPERATORS[:common]).uniq
    if lov_flag
       available_ops =Irm::RuleFilterCriterion::OPERATORS[:lov]
    end
    operators.collect{|o| [o[:meaning],o[:lookup_code]] if available_ops.include?(o[:lookup_code])}.compact
  end

  def render_nil_object_attribute(form)
    operators = view_filter_operators(:common)
    operator_tag = form.blank_select(:operator_code,operators, {:required=>true},{:style=>"min-width:150px"})
    operator_tag = content_tag(:div,operator_tag,{:style=>"display:inline; padding-right: 10px;"},false)
    value_tag = ""
    value_tag = form.text_field :filter_value,:size=>30
    value_tag = content_tag(:div,value_tag,{:style=>"display:inline;"},false)
    (operator_tag + value_tag).html_safe
  end

end
