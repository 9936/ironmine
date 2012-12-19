module Irm::ObjectAttributesHelper
  def newable_attribute_type
    delete_types = ["TABLE_COLUMN","LOOKUP_COLUMN","MASTER_DETAIL_COLUMN"]
    attribute_types = Irm::LookupValue.query_by_lookup_type("BO_ATTRIBUTE_TYPE").multilingual.collect{|p|[p[:meaning],p[:lookup_code]]}
    attribute_types.delete_if{|at| delete_types.include?(at[1])}
    attribute_types
  end

  def changeable_attribute_type
    attribute_types = Irm::LookupValue.query_by_lookup_type("BO_ATTRIBUTE_TYPE").multilingual.collect{|p|[p[:meaning],p[:lookup_code]]}
    attribute_types
  end

  def available_object_attribute_field_type
    field_types = Irm::LookupValue.query_by_lookup_type("BO_ATTRIBUTE_FIELD_TYPE").multilingual.collect{|p|[p[:meaning],p[:lookup_code]]}
    field_types
  end


  def available_object_attribute(business_object_id)
    Irm::ObjectAttribute.enabled.multilingual.table_column.where(:business_object_id=>business_object_id).collect{|i|[i[:name],i.id]}
  end
  # only table column
  def available_relationable_object_attribute(business_object_code=nil)
    object_attributes =[]
    if business_object_code
      object_attributes = Irm::ObjectAttribute.table_column.query_by_status_code("ENABLED").multilingual.query_by_business_object_code(business_object_code)
    end
    object_attributes.collect{|i|[i.attribute_name,i.attribute_name,{:attribute_name=>i.attribute_name}]}
  end

  # table column and relation column
  def available_selectable_object_attribute(business_object_code=nil)
    object_attributes =[]
    if business_object_code
      object_attributes = Irm::ObjectAttribute.selectable_column.query_by_status_code("ENABLED").multilingual.query_by_business_object_code(business_object_code)
    end
    object_attributes.collect{|i|[i.attribute_name,i.attribute_name,{:attribute_name=>i.attribute_name}]}
  end

  # only table column
  def available_updatedable_object_attribute(business_object_code=nil)
    object_attributes =[]
    if business_object_code
      object_attributes = Irm::ObjectAttribute.updateable_column.enabled.multilingual.query_by_business_object_code(business_object_code)
    end
    object_attributes.collect{|i|[i.attribute_name,i.attribute_name,{:attribute_name=>i.attribute_name}]}
  end

  def object_attribute_categories
    categories = {}
    Irm::LookupValue.multilingual.query_by_lookup_type("BO_ATTRIBUTE_CATEGORY").each do |c|
      categories[c[:lookup_code]] = c
    end
    categories
  end

  def standard_object_attributes(bo_id)
    Irm::ObjectAttribute.multilingual.list_all.real_field.query_by_business_object(bo_id).where("#{Irm::ObjectAttribute.table_name}.field_type = ?","STANDARD_FIELD")
  end

  def customize_object_attributes(bo_id)
    Irm::ObjectAttribute.multilingual.list_all.real_field.query_by_business_object(bo_id).where("#{Irm::ObjectAttribute.table_name}.field_type = ?","CUSTOMED_FIELD")
  end

  def user_customize_object_attributes(bo_id)
    Irm::ObjectAttribute.multilingual.list_all.real_field.query_by_business_object(bo_id).where("#{Irm::ObjectAttribute.table_name}.field_type = ?","GLOBAL_CUX_FIELD")
  end

  def global_customize_object_attribute_names(bo)
    #已经存在的全局用户自定义属性
    g_attributes = Irm::ObjectAttribute.multilingual.list_all.real_field.query_by_business_object(bo.id).where("#{Irm::ObjectAttribute.table_name}.field_type = ?","GLOBAL_CUX_FIELD").collect{|i| i.attribute_name}
    columns = []
    tcs = ActiveRecord::Base.connection.execute("DESCRIBE  #{bo.bo_table_name}")
    tcs.each do |c|
      columns << c[0] if c[0].start_with?("attribute")&&!g_attributes.include?(c[0])
    end
    columns
  end

  def show_object_attribute_category(data)
    case data[:category]
      when "LOOKUP_RELATION","MASTER_DETAIL_RELATION"
        return "#{data[:category_name]}(#{data[:relation_bo_name]})"
      when "DATE_TIME","CHECK_BOX","PICK_LIST","PICK_LIST_MULTI", "DATE"
        return data[:category_name]
      when "EMAIL","NUMBER" ,"TEXT","TEXT_AREA" ,"TEXT_AREA_RICH","URL"
        return "#{data[:category_name]}(#{data.data_length})"
      else
        return data[:attribute_type_name]
    end
  end

  def show_object_attribute_value(data)
    hand_value(data[:category], data[:data_default_value])
  end

  #根据不同的类型设置默认值
  def attribute_default_value(type, form)
    case type
      when "DATE_TIME"
        return form.date_field :data_default_value,:id=>"object_attribute_data_default_value",:size=>12,:class=>"date",:with_time => true
      when "DATE"
        return form.date_field :data_default_value,:id=>"object_attribute_data_default_value",:size=>12,:class=>"date"
      when "CHECK_BOX"
        return form.check_box :data_default_value,:id=>"object_attribute_data_default_value"
      else
        return form.text_field :data_default_value,:id=>"object_attribute_data_default_value"
    end
  end

end
