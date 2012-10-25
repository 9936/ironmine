class AddSendTypeToMailAlerts < ActiveRecord::Migration
  def change
    add_column :irm_wf_mail_alerts, :all_flag, :string, :default => "N", :after => "bo_code"
  end
end
