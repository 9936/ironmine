class Irm::WfSetting < ActiveRecord::Base
  set_table_name :irm_wf_settings

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  def self.email_approval?
    setting = self.first
    setting&&setting.email_approval_flag.eql?(Irm::Constant::SYS_YES)
  end
end
