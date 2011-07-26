class Irm::ReportFoldersTl < ActiveRecord::Base
  set_table_name :irm_report_folders_tl

  belongs_to :report_folder
end
