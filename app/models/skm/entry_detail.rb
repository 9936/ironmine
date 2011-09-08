class Skm::EntryDetail < ActiveRecord::Base
  set_table_name :skm_entry_details
  belongs_to :entry_header
  
  validate :validate_content

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu

  def validate_content
    errors.add(:entry_content, "can not be none") if required_flag == "Y" && entry_content.blank? 
  end

  #acts_as_recently_objects(:title => "entry_title",
  #                         :target_controller => "skm/entry_headers",
  #                         :target => "entry_header")
end