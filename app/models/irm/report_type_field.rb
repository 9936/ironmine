class Irm::ReportTypeField < ActiveRecord::Base
  set_table_name :irm_report_type_fields

  belongs_to :report_type_section,:primary_key => "section_id"

  scope :with_business_attribute,lambda{
    joins("JOIN #{Irm::ObjectAttribute.table_name} ON #{Irm::ObjectAttribute.table_name}.id = #{table_name}.object_attribute_id").
    joins("JOIN #{Irm::BusinessObject.table_name} ON #{Irm::ObjectAttribute.table_name}.business_object_code = #{Irm::BusinessObject.table_name}.business_object_code")
  }
  scope :query_by_report_type,lambda{|report_type_id|
    joins("JOIN #{Irm::ReportTypeSection.table_name} ON #{Irm::ReportTypeSection.table_name}.id = #{table_name}.section_id").
    where("#{Irm::ReportTypeSection.table_name}.report_type_id = ?",report_type_id)
  }

  scope :not_in_bo_ids,lambda{|bo_ids|
    where("#{Irm::BusinessObject.table_name}.id NOT IN (?)",bo_ids)
  }

  def self.delete_not_allowed(bo_ids,report_type_id)
    self.with_business_attribute.not_in_bo_ids(bo_ids).query_by_report_type(report_type_id).each do |f|
      f.destroy
    end
  end


end
