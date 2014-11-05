include ActionView::Helpers::SanitizeHelper

class Mam::System < ActiveRecord::Base
  set_table_name :mam_systems
  query_extend

  # 对运维中心数据进行隔离
  default_scope {default_filter}

end
