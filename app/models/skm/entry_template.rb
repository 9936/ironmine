class Skm::EntryTemplate < ActiveRecord::Base
  set_table_name :skm_entry_templates
  validates_presence_of :entry_template_code
  validates_uniqueness_of :entry_template_code,:scope=>[:opu_id]
  validates_presence_of :name

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
end