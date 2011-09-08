class Irm::ReportTypeSection < ActiveRecord::Base
  set_table_name :irm_report_type_sections

  belongs_to :report_type
  has_many :report_type_fields,:foreign_key => "section_id" , :dependent => :destroy

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  def self.init_fields(bo_ids,report_type_id)
    bo_ids.each_with_index do |bid,index|
      bo = Irm::BusinessObject.multilingual.find(bid)
      section = self.create(:report_type_id=>report_type_id,:name=>bo[:name],:section_sequence=>index)
      bo.object_attributes.each do |oa|
        next if oa.attribute_type.eql?("MODEL_COLUMN")
        section.report_type_fields.create(:section_id=>section.id,:object_attribute_id=>oa.id,:default_selection_flag=>"N")
      end
    end
  end
end
