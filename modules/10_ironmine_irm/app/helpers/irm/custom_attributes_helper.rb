module Irm::CustomAttributesHelper

  def system_custom_attributes(bo_id, sid)
    system_custom_attributes = Irm::ObjectAttribute.multilingual.list_all.real_field.query_by_business_object(bo_id).where("#{Irm::ObjectAttribute.table_name}.field_type = ? AND #{Irm::ObjectAttribute.table_name}.external_system_id=?","SYSTEM_CUX_FIELD", sid)
    system_custom_attributes + Irm::ObjectAttribute.multilingual.list_all.real_field.query_by_business_object(bo_id).with_external_system(sid).where("#{Irm::ObjectAttribute.table_name}.field_type = ?","GLOBAL_CUX_FIELD")
  end

  def global_custom_attributes(bo_id,sid)
    Irm::ObjectAttribute.multilingual.list_all.real_field.without_external_system(sid).query_by_business_object(bo_id).where("#{Irm::ObjectAttribute.table_name}.field_type = ?","GLOBAL_CUX_FIELD")
  end

  def system_custom_attribute_names(bo, sid)
    #已经存在的系统用户自定义属性
    g_attributes = Irm::ObjectAttribute.multilingual.list_all.real_field.query_by_business_object(bo.id).where("#{Irm::ObjectAttribute.table_name}.field_type = ? AND #{Irm::ObjectAttribute.table_name}.external_system_id=?","SYSTEM_CUX_FIELD", sid).collect{|i| i.attribute_name}
    columns = []
    tcs = ActiveRecord::Base.connection.execute("DESCRIBE  #{bo.bo_table_name}")
    tcs.each do |c|
      columns << c[0] if c[0].start_with?("sattribute")&&!g_attributes.include?(c[0])
    end
    columns
  end
end