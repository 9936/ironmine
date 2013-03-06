class Slm::CalendarItemsTl < ActiveRecord::Base
  set_table_name :slm_calendar_items_tl

  belongs_to :calendar_item
end