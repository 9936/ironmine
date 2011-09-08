class Irm::ReportGroupColumn < ActiveRecord::Base
  set_table_name :irm_report_group_columns

  belongs_to :report

  belongs_to :report_type_field,:foreign_key => :field_id

  before_save :setup_group_date_type

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu

  scope :with_object_attribute,lambda{
    joins("JOIN #{Irm::ReportTypeField.table_name} ON #{Irm::ReportTypeField.table_name}.id = #{table_name}.field_id ").
    joins("JOIN #{Irm::ObjectAttribute.table_name} ON #{Irm::ObjectAttribute.table_name}.id = #{Irm::ReportTypeField.table_name}.object_attribute_id ").
    joins("JOIN #{Irm::BusinessObject.table_name} ON #{Irm::BusinessObject.table_name}.business_object_code = #{Irm::ObjectAttribute.table_name}.business_object_code ").
    select("#{Irm::BusinessObject.table_name}.id business_object_id,#{Irm::ObjectAttribute.table_name}.id object_attribute_id,#{Irm::ObjectAttribute.table_name}.attribute_name object_attribute_name,#{table_name}.field_id report_type_field_id")
  }

  scope :select_sequence,lambda{
    select("#{table_name}.seq_num,#{table_name}.group_date_type")
  }

  def setup_group_date_type
    return true unless self.field_id.present?
    oa = Irm::ObjectAttribute.find(self.report_type_field.object_attribute_id)
    unless(oa&&oa.data_type.present?&&oa.data_type.eql?("datetime"))
      self.group_date_type = nil
    end
  end

  def clear_id
    tmp_id = self.id
    self.id = ""
    return tmp_id
  end

end
