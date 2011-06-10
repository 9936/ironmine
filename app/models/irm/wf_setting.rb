class Irm::WfSetting < ActiveRecord::Base
  set_table_name :irm_wf_settings
  def self.email_approval?
    setting = self.first
    setting&&setting.email_approval_flag.eql?(Irm::Constant::SYS_YES)
  end
end
