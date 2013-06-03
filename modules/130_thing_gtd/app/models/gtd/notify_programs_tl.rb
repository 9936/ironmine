class Gtd::NotifyProgramsTl < ActiveRecord::Base
  set_table_name :gtd_notify_programs_tl

  belongs_to :notify_program
end