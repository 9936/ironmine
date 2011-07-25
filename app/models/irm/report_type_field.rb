class Irm::ReportTypeField < ActiveRecord::Base
  set_table_name :irm_report_type_fields

  belongs_to :report_type_section
  has_many :report_criterion
  query_extend

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

  scope :with_bo_object_attribute,lambda{|language|
    joins("JOIN #{Irm::ObjectAttribute.view_name} ON #{Irm::ObjectAttribute.view_name}.id = #{table_name}.object_attribute_id AND #{Irm::ObjectAttribute.view_name}.language='#{language}'").
    joins("JOIN #{Irm::BusinessObject.view_name} ON #{Irm::ObjectAttribute.view_name}.business_object_code = #{Irm::BusinessObject.view_name}.business_object_code AND #{Irm::BusinessObject.view_name}.language='#{language}'").
    select("#{Irm::BusinessObject.view_name}.id business_object_id,#{Irm::BusinessObject.view_name}.name business_object_name,#{Irm::ObjectAttribute.view_name}.attribute_name,#{Irm::ObjectAttribute.view_name}.name object_attribute_name,#{Irm::ObjectAttribute.view_name}.data_type")
  }

  scope :date_column,lambda{
    where("#{Irm::ObjectAttribute.view_name}.data_type = ?","datetime")
  }

  scope :filter_column,lambda{
    where("#{Irm::ObjectAttribute.view_name}.filter_flag = ?",Irm::Constant::SYS_YES)
  }

  scope :select_all,lambda{select("#{table_name}.*")}

  def self.delete_not_allowed(bo_ids,report_type_id)
    self.with_business_attribute.not_in_bo_ids(bo_ids).query_by_report_type(report_type_id).each do |f|
      f.destroy
    end
  end


end
