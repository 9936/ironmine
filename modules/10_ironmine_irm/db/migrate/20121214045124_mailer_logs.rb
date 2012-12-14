class MailerLogs < ActiveRecord::Migration
  def up
    create_table :irm_mailer_logs do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.text     "reference_target"
      t.string   "to_params",     :limit => 100, :null => false
      t.string   "template_code",   :limit => 50
      t.datetime "send_at"
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_mailer_logs, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end

  def down
    drop_table :irm_mailer_logs
  end
end
