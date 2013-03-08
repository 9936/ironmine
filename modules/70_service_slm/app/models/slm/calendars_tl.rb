class Slm::CalendarsTl < ActiveRecord::Base
  set_table_name :slm_calendars_tl

  belongs_to :calendar
end