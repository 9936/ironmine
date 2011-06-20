class CreateTableIrmDelayedJobLogs < ActiveRecord::Migration
  def self.up
    create_table :irm_delayed_job_logs, :force => true do |t|
      t.integer :delayed_job_id
      t.integer :priority
      t.integer :attempts
      t.text  :handler
      t.text :last_error
      t.datetime :run_at
      t.datetime :end_at
      t.datetime :failed_at
      t.datetime :locked_at
      t.string   "status_code", :limit => 30, :default=>"ENABLED"
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    drop_table :irm_delayed_job_logs
  end
end
