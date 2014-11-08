include ActionView::Helpers::SanitizeHelper

class Mam::MasterUr < ActiveRecord::Base
  set_table_name :mam_master_scs
  query_extend

  # 对运维中心数据进行隔离
  default_scope {default_filter}

end
