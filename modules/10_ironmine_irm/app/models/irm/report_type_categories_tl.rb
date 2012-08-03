class Irm::ReportTypeCategoriesTl < ActiveRecord::Base
  set_table_name :irm_report_type_categories_tl

  belongs_to :report_type_category

  validates_presence_of :name

end
