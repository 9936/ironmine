class Irm::DelayedJobLogItem < ActiveRecord::Base
  set_table_name :irm_delayed_job_log_items
  belongs_to :delayed_job_log, :primary_key => "delayed_job_id", :foreign_key => "delayed_job_id"
  query_extend

  scope :select_all, lambda{|delayed_job_id|
    select("#{table_name}.*").
        where("#{table_name}.delayed_job_id = ?", delayed_job_id)
  }

  scope :with_job_status, lambda{
    select("lvt.meaning job_status_name").
        joins(",#{Irm::LookupValue.table_name} lv, #{Irm::LookupValuesTl.table_name} lvt").
        where("lv.id = lvt.lookup_value_id").
        where("lv.lookup_type = ?", "IRM_DELAYED_JOB_STATUS").
        where("lvt.language = ?", I18n.locale).
        where("lv.lookup_code = #{table_name}.job_status")
  }

  def self.list_all(delayed_job_id)
    select_all(delayed_job_id).with_job_status
  end
end