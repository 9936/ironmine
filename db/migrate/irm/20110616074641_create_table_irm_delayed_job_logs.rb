class CreateTableIrmDelayedJobLogs < ActiveRecord::Migration
  def self.up
    create_table :irm_delayed_job_logs, :force => true do |t|
      t.integer :delayed_job_id
      t.integer :priority    #优先级
      t.integer :attempts    #重试次数
      t.text  :handler       #处理程序
      t.text :last_error     #最后错误信息
      t.datetime :run_at     #开始执行时间
      t.datetime :end_at     #结束时间
      t.datetime :failed_at  #执行失败时间
      t.datetime :locked_at  #锁定时间
      t.text :locked_by      #锁定者
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
