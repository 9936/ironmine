include ActionView::Helpers::SanitizeHelper

class Mam::SystemGroup < ActiveRecord::Base
  set_table_name :mam_system_groups
  query_extend

  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_support_group, lambda{|language|
      select("isgv.name support_group_name, isgv.id support_group_id").
      joins(", icm_support_groups_vl isgv").where("isgv.language = ?", language).
      where("#{table_name}.support_group_id = isgv.id")
  }
end
