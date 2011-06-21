class CreateTableIrmDelayedJobLogItems < ActiveRecord::Migration
  def self.up
    create_table :irm_delayed_job_log_items, :force => true do |t|
      t.integer :delayed_job_id
      t.text :content     #日志内容
      t.string :job_status, :limit => 30 #当前执行状态
      t.string   "status_code", :limit => 30, :default=>"ENABLED"
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    drop_table :irm_delayed_job_log_items
  end
end
