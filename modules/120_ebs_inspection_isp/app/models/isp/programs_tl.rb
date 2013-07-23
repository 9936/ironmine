class Isp::ProgramsTl < ActiveRecord::Base
  set_table_name :isp_programs_tl

  belongs_to :program
end