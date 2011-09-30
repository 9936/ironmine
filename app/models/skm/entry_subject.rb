class Skm::EntrySubject < ActiveRecord::Base
  set_table_name :skm_entry_subjects

  belongs_to :entry_header
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
  def all_available_subjects(subject_type)
    Irm::FlexValue.query_by_value_set_name(subject_type)
  end
end