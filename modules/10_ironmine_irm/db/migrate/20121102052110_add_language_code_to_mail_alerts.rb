class AddLanguageCodeToMailAlerts < ActiveRecord::Migration
  def change
    add_column :irm_wf_mail_alerts, :language_code, :string, :after => "bo_code"
  end
end
