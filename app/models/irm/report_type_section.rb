class Irm::ReportTypeSection < ActiveRecord::Base
  set_table_name :irm_report_type_sections

  belongs_to :report_type
  has_many :report_type_fields


  def self.init_fields(bo_ids,report_type_id)
    bo_ids.each_with_index do |bid,index|
      bo = Irm::BusinessObject.multilingual.find(bid)
      section = self.create(:report_type_id=>report_type_id,:name=>bo[:name],:section_sequence=>index)
      bo.object_attributes.each do |oa|
        section.report_type_fields.create(:section_id=>section.id,:object_attribute_id=>oa.id,:default_selection_flag=>"N")
      end
    end
  end
end
