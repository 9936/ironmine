include ActionView::Helpers::SanitizeHelper

class Mam::MasterUr < ActiveRecord::Base
  set_table_name :mam_master_urs
  query_extend
  belongs_to :master
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_action, lambda{
    select("lvt.meaning action_name").
        joins("LEFT OUTER JOIN irm_lookup_values_vl lvt ON lvt.language = 'en' AND lvt.lookup_type = 'MAM_UR_ACTION' AND lvt.lookup_code = #{table_name}.action")
  }
end
