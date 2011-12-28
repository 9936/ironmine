class Irm::ReportRequestHistory < ActiveRecord::Base
  set_table_name :irm_report_request_histories

  serialize :params, Hash

  query_extend

  scope :with_executed_by,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} executed ON  executed.id = #{table_name}.executed_by").
    select("executed.full_name executed_name")
  }

  scope :with_report,lambda{|language|
    joins("JOIN #{Irm::Report.view_name} report ON report.id = #{table_name}.report_id AND report.language='#{language}'").
        select("report.name report_name")
  }


  def self.list_all
    select_all.with_executed_by.with_report(I18n.locale)
  end

  def elapse
    self.end_at - self.start_at
  end

end
