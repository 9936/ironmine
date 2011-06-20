class Irm::DelayedJobLogItem < ActiveRecord::Base
  set_table_name :irm_delayed_job_log_items
  belongs_to :delayed_job_log, :primary_key => "delayed_job_id", :foreign_key => "delayed_job_id"
  query_extend

  scope :select_all, lambda{|delayed_job_id|
    select("#{table_name}.*").
        where("#{table_name}.delayed_job_id = ?", delayed_job_id)
  }

  def self.list_all(delayed_job_id)
    select_all(delayed_job_id)
  end
end