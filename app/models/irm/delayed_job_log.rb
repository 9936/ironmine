class Irm::DelayedJobLog < ActiveRecord::Base
  set_table_name :irm_delayed_job_logs
  has_many :delayed_job_log_items, :primary_key => "delayed_job_id", :foreign_key => "delayed_job_id"
  query_extend

  scope :select_all, lambda{
    select("#{table_name}.*")
  }

  scope :with_job_status, lambda{
    select("(SELECT lvt.meaning FROM #{Irm::DelayedJobLogItem.table_name} li, #{Irm::LookupValue.table_name} lv,
            #{Irm::LookupValuesTl.table_name} lvt
            WHERE li.delayed_job_id = #{table_name}.delayed_job_id
              AND lv.lookup_type = 'IRM_DELAYED_JOB_STATUS' AND lvt.language='zh' AND lvt.lookup_value_id = lv.id AND lv.lookup_code = li.job_status
            ORDER BY li.id DESC LIMIT 1) job_status")
  }

  def self.list_all
    select_all.with_job_status.order("created_at DESC")
  end
end