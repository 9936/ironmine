class AlertMailRecipients < ActiveRecord::Migration
  def up
    change_column :irm_wf_mail_recipients, "recipient_id", :string, :null => false, :limit=>50, :collate=>"utf8_bin"
  end

  def down
    change_column :irm_wf_mail_recipients, "recipient_id", :string, :null => false, :limit=>22, :collate=>"utf8_bin"
  end
end
