include ActionView::Helpers::SanitizeHelper

class Mam::Master < ActiveRecord::Base
  set_table_name :mam_masters
  query_extend
  has_many :master_scs
  has_many :master_urs
  has_many :master_items
  # 对运维中心数据进行隔离
  default_scope {default_filter}

end
