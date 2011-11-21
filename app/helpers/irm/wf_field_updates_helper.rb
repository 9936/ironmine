module Irm::WfFieldUpdatesHelper
  def bo_attribute(bo_code,object_attribute)
    Irm::ObjectAttribute.query_by_business_object_code(bo_code).where(:attribute_name=>object_attribute).first
  end
end
