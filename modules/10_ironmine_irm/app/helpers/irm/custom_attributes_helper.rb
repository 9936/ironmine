module Irm::CustomAttributesHelper

  def system_custom_attributes(bo_id, sid)
    #查询出所有自定义字段(包括全局和系统层)
    all_attributes = Irm::ObjectAttribute.multilingual.list_all.real_field.query_by_business_object(bo_id).custom_field_with_system(sid).order_by_sequence
    #查找出系统下已经启用的自定义字段
    system_attributes = Irm::ObjectAttributeSystem.where(:external_system_id => sid).index_by(&:object_attribute_id)
    active_attributes = []
    disabled_attributes = []
    all_attributes.each do |attribute|
      if system_attributes[attribute.id] or attribute[:system_flag].eql?('Y')
        attribute[:active_flag] = 'Y'
        #attribute[:display_color] = "#5bb75b"
        active_attributes << attribute
      else
        attribute[:active_flag] = 'N'
        attribute[:display_color] = "#faa732"
        disabled_attributes << attribute
      end
    end

    active_attributes + disabled_attributes
  end

  def can_reordered?(bo_id, sid)
    system_attributes = Irm::ObjectAttribute.query_by_business_object(bo_id).where("external_system_id=?", sid)
    if system_attributes.any? and system_attributes.size > 1
      true
    else
      false
    end
  end

  def global_custom_attributes(bo_id,sid)
    Irm::ObjectAttribute.multilingual.list_all.real_field.without_external_system(sid).query_by_business_object(bo_id).where("#{Irm::ObjectAttribute.table_name}.field_type = ?","GLOBAL_CUX_FIELD")
  end

  def has_available_global_fields?(bo_id,sid)
    Irm::ObjectAttribute.without_external_system(sid).query_by_business_object(bo_id).where("#{Irm::ObjectAttribute.table_name}.field_type = ?","GLOBAL_CUX_FIELD").any?
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