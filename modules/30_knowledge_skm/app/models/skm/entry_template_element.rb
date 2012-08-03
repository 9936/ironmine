class Skm::EntryTemplateElement < ActiveRecord::Base
  set_table_name :skm_entry_template_elements
  has_many :entry_template_details

  validates_presence_of :entry_template_element_code,:default_rows
  validates_numericality_of :default_rows
  validates_uniqueness_of :entry_template_element_code,:scope=>[:opu_id]
  validates_presence_of :name

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_template, lambda{|template_id|
    select("#{table_name}.*, et.required_flag required_flag, et.id detail_id, et.default_rows detail_rows, et.required_flag detail_required_flag").
    joins(",#{Skm::EntryTemplateDetail.table_name} et").
    where("et.entry_template_id = ?", template_id).
    where("et.entry_template_element_id = #{table_name}.id").
    order("et.line_num ASC")
  }

  scope :without_template, lambda{|template_id|
    select("#{table_name}.*").
    where("#{table_name}.id NOT IN (SELECT entry_template_element_id FROM #{Skm::EntryTemplateDetail.table_name} et WHERE et.entry_template_id = ?)", template_id)
  }
end