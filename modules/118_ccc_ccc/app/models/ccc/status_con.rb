class Ccc::StatusCon < ActiveRecord::Base
  set_table_name :ccc_status_cons

  query_extend
  acts_as_customizable

  attr_accessor :status_codes,:profile_types
end
