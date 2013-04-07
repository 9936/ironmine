class Isp::ProgramsTl < ActiveRecord::Base
  set_table_name :sip_programs_tl

  belongs_to :program
end