class Irm::ReportHistory < ActiveRecord::Base
  set_table_name :irm_report_histories

  serialize :params, Hash

  query_extend

  scope :with_executed_by,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} executed ON  executed.id = #{table_name}.executed_by").
    select("executed.full_name executed_name")
  }


  def list_all
    select_all.with_executed_by
  end

end
