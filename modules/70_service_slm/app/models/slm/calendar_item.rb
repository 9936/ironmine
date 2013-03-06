class Slm::CalendarItem < ActiveRecord::Base
  set_table_name :slm_calendar_items

  attr_accessor :start_time, :end_time, :weeks_str
  belongs_to :calendar

  validates_presence_of :calendar_id

  #acts_as_multilingual

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }


  scope :with_calendar, lambda { |calendar_id|
    where("calendar_id=?", calendar_id)
  }

  scope :with_years, lambda {|years|
    where("calendar_year IN(?)", years)
  }

  scope :with_active, where("deadline > ?", Time.now)

  scope :without_all, where("relation_type <>?", "ALL")

  scope :order_by_type, order("relation_type ASC")

  def time_mode_obj
    return @time_mode_obj if @time_mode_obj
    @time_mode_obj = prepare_time_mode
  end


  def hand_calendar_item
    self.start_time = Time.strptime("#{self.start_time} 00:00:00", '%Y-%m-%d %T')
    self.end_time = Time.strptime("#{self.end_time} 00:00:00", '%Y-%m-%d %T')

    if self.start_time < self.end_time and self.start_time.day != self.end_time.day
      years_obj = {}
      if self.weeks_str.present?
        week_days = self.weeks_str
      else
        week_days = ["1","2","3","4","5","6","0"]
      end

      while start_time <= end_time
        year, month, day, wday = start_time.year, start_time.month, start_time.day, start_time.wday
        years_obj[year] ||= {}
        years_obj[year][month] ||= []
        years_obj[year][month] << day if week_days.include?(wday.to_s)
        self.start_time = self.start_time + 1.day

      end
      years_obj.each do |year, month_obj|
        year_start_end_item = Slm::CalendarItem.where("calendar_id=? AND calendar_year=? AND start_at=? AND end_at=?", self.calendar_id, year, self.start_at, self.end_at).first
        if year_start_end_item.present?
          year_start_end_item.calendar_obj = month_obj
        else
          Slm::CalendarItem.create(:start_at => self.start_at,
                                   :end_at => self.end_at,
                                   :calendar_id => self.calendar_id,
                                   :calendar_obj => month_obj.to_s,
                                   :calendar_year => year)
        end
      end if years_obj.any?

    end

  end

  private
  def prepare_time_mode
    if self.time_mode.present?
      return YAML.load(self.time_mode)
    else
      {
          :freq => "DAILY",
          :daily => {:type => "BYDAY", :interval => "1"},
          :yearly => {:type => "BYEARY", :interval => "1"},
          :weekly => {:interval => "1", :days => ["MO"]},
          :monthly => {:type => "WEEK", :day => {:interval => "1", :dayno => "1"}, :week => {:interval => "1", :weekno => "1", :weekday => "MO"}}
      }
    end
  end
end
