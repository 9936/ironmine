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
    Irm::ObjectAttribute.multilingual.list_all.real_field.query_by_business_object(bo_id).where("#{Irm::ObjectAttribute.table_name}.field_type != ?","STANDARD_FIELD")
  end

  def show_object_attribute_category(data)
    case data[:category]
      when "LOOKUP_RELATION","MASTER_DETAIL_RELATION"
        return "#{data[:category_name]}(#{data[:relation_bo_name]})"
      when "DATE_TIME","CHECK_BOX","PICK_LIST","PICK_LIST_MULTI"
        return data[:category_name]
      when "EMAIL","NUMBER" ,"TEXT","TEXT_AREA" ,"TEXT_AREA_RICH","URL"
        return "#{data[:category_name]}(#{data.data_length})"
      else
        return data[:attribute_type_name]
    end
  end

end
