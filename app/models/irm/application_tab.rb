class Irm::ApplicationTab < ActiveRecord::Base
  set_table_name :irm_application_tabs

  belongs_to :applicaiton
  belongs_to :tab
end
