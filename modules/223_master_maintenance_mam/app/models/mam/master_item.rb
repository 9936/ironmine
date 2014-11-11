include ActionView::Helpers::SanitizeHelper

class Mam::MasterItem < ActiveRecord::Base
  set_table_name :mam_master_items
  query_extend
  belongs_to :master
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_template, lambda{
    select("lvt.meaning template_name, lvt.lookup_code template_code").
    joins(",irm_lookup_values_vl lvt").
        where("lvt.language = 'en'").
        where("lvt.lookup_type = ?", "MAM_TEMPLATE").
        where("lvt.lookup_code = #{table_name}.template")
  }
end
