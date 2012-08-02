class Irm::ReportTypesTl < ActiveRecord::Base
  set_table_name :irm_report_types_tl

  belongs_to :report_type

  validates_presence_of :name
end
