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


  def available_object_attribute(business_object_code=nil)
    object_attributes =[]
    if business_object_code
      object_attributes = Irm::ObjectAttribute.query_by_status_code("ENABLED").multilingual.where(:business_object_code=>business_object_code)
    else
      object_attributes = Irm::ObjectAttribute.query_by_status_code("ENABLED").multilingual
    end
    object_attributes.collect{|i|[i[:name],i.attribute_name]}
  end
  # only table column
  def available_relationable_object_attribute(business_object_code=nil)
    object_attributes =[]
    if business_object_code
      object_attributes = Irm::ObjectAttribute.table_column.query_by_status_code("ENABLED").multilingual.where(:business_object_code=>business_object_code)
    end
    object_attributes.collect{|i|[i.attribute_name,i.attribute_name,{:attribute_name=>i.attribute_name}]}
  end

  # table column and relation column
  def available_selectable_object_attribute(business_object_code=nil)
    object_attributes =[]
    if business_object_code
      object_attributes = Irm::ObjectAttribute.selectable_column.query_by_status_code("ENABLED").multilingual.where(:business_object_code=>business_object_code)
    end
    object_attributes.collect{|i|[i.attribute_name,i.attribute_name,{:attribute_name=>i.attribute_name}]}
  end

  # only table column
  def available_updatedable_object_attribute(business_object_code=nil)
    object_attributes =[]
    if business_object_code
      object_attributes = Irm::ObjectAttribute.updateable_column.enabled.multilingual.where(:business_object_code=>business_object_code)
    end
    object_attributes.collect{|i|[i.attribute_name,i.attribute_name,{:attribute_name=>i.attribute_name}]}
  end
end
