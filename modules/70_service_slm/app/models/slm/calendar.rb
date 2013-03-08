class Slm::Calendar < ActiveRecord::Base
  set_table_name :slm_calendars

  #多语言关系
  attr_accessor :name,:description
  has_many :calendars_tls, :dependent => :destroy
  has_many :calendar_items, :dependent => :destroy

  acts_as_multilingual

  validates_presence_of :external_system_id

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_system, lambda {|external_system_id|
    where("external_system_id=?", external_system_id)
  }

  scope :query_by_year, lambda {|year|
    where("calendar_year=?", year)
  }

  def next_working_time(time, duration = 0)
    if time.is_a?(String)
      time = Time.strptime(time, '%Y-%m-%d %T')
    end

    years = []
    year = time.year
    years << year
    years << year + 1

   items = Slm::CalendarItem.with_calendar(self.id).with_years(years).ordered

    calendar_items_obj = []
    items.each do |item|
      item_obj = {}
      item_obj[:calendar_obj]  = {item[:calendar_year] => eval(item[:calendar_obj])}
      item_obj[:start_at] = item[:start_at]
      item_obj[:end_at] = item[:end_at]
      calendar_items_obj << item_obj
    end

    duration_seconds = duration * 60
    if calendar_items_obj.any?
      next_working_time_at(time, duration_seconds, calendar_items_obj)
    else
      time + duration_seconds
    end
  end

  #计算当前工作日历下的工作时间
  def working_time(start_time, end_time)
    if start_time.is_a?(String)
      start_time = Time.strptime(start_time, '%Y-%m-%d %T')
    end

    if end_time.is_a?(String)
      end_time = Time.strptime(end_time, '%Y-%m-%d %T')
    end

    if start_time > end_time
      return 0
    end

    years = []
    (start_time.year..end_time.year).each do |year|
      years << year
    end

    total_work_time = 0

    calendar_items = Slm::CalendarItem.with_calendar(self.id).with_years(years).ordered

    end_year = end_time.year
    end_month = end_time.month
    end_day = end_time.day
    end_hour = end_time.hour
    end_minute = end_time.min

    calendar_items_obj ||= {}

    calendar_items.each do |item|
      current_start_time = start_time.dup

      while current_start_time <= end_time
        start_year = current_start_time.year
        start_month = current_start_time.month

        calendar_items_obj[start_year] = eval(item[:calendar_obj])

        if calendar_items_obj[start_year] && calendar_items_obj[start_year][start_month] && calendar_items_obj[start_year][start_month].any?

          start_day = current_start_time.day

          format_date_str = "#{start_year}-#{start_month}-#{start_day}"

          item_option = format_item_time(item[:start_at], item[:end_at],format_date_str)
          if start_year.eql?(end_year) && start_month.eql?(end_month) && start_day.eql?(end_day)
            current_end_hour = end_hour
            current_end_minute = end_minute
          else
            current_end_hour = item_option[:end_at].hour
            current_end_minute = item_option[:start_at].min
          end
          days = calendar_items_obj[start_year][start_month]
          if days.include?(start_day)
            start_hour = current_start_time.hour
            start_minute = current_start_time.min

            start_hour_minute = format_time(start_hour, start_minute, format_date_str)
            end_hour_minute = format_time(current_end_hour, current_end_minute, format_date_str)

            total_work_time += calculate_minutes(start_hour_minute, end_hour_minute , item_option)
          end
        end
        #将current_start_time的时间设置到0点
        current_start_time = Time.parse("00:00", current_start_time)
        current_start_time += 1.day
      end
    end if calendar_items.any?
    total_work_time
  end

  private
    #获取指定班次的时间
    def calculate_minutes(start_hour_minute, end_hour_minute, item)
      item_start = item[:start_at]
      item_end = item[:end_at]

      duration_seconds = 0
      if start_hour_minute < item_start
        start_hour_minute = item_start
      end

      if end_hour_minute > item_end
        end_hour_minute = item_end
      end

      if start_hour_minute < end_hour_minute
        duration_seconds = end_hour_minute - start_hour_minute
      end
      duration_seconds
    end

    #将分钟和小时用固定的时间年月日进行格式化，便于比较操作
    def format_time(hour, minute, format_date_str = "2013-01-01")
      format_date_str = format_date_str + " #{hour}:#{minute}:00"
      Time.strptime(format_date_str, '%Y-%m-%d %T')
    end

    def format_item_time(item_start, item_end, format_date_str= "2013-01-01")
      item_option = {}
      item_option[:start_at] = Time.strptime("#{format_date_str} #{item_start}:00", '%Y-%m-%d %T')
      item_option[:end_at] = Time.strptime("#{format_date_str} #{item_end}:00", '%Y-%m-%d %T')
      item_option
    end

    def next_working_time_at(time, duration = 0, calendar_items_obj=[])
      unless duration > 0
        return time
      end

      year, month, day = time.year, time.month, time.day
      schedule_days = {}

      calendar_items_obj.each do |item|
        calendar_obj = item[:calendar_obj]
        if calendar_obj and calendar_obj[year.to_s] && calendar_obj[year.to_s][month] && calendar_obj[year.to_s][month].include?(day)
          schedule_days[day] ||= []
          schedule_days[day] << item
        end
      end
      work_seconds = 0

      schedule_duration = duration
      if schedule_days.any? && schedule_days[day].any?
        schedule_days[day].each do |item|
          item_option = format_item_time(item[:start_at], item[:end_at], "#{year}-#{month}-#{day}")

          #时间不超出班次范围给予计算
          if item_option[:start_at] > time
            time = item_option[:start_at]
          end
          if item_option[:start_at] <= time && item_option[:end_at] >= time
            work_seconds += calculate_minutes(time, (time + duration), item_option)

            if work_seconds < duration
              time = item_option[:end_at]
              schedule_duration = schedule_duration - work_seconds
            else
              break
            end
          end
        end
      end

      if work_seconds < duration
        time = time + 1.day
        time = Time.parse("00:00", time)
        time = next_working_time_at(time, (duration - work_seconds), calendar_items_obj)
      else
        time = time + schedule_duration
      end

      time
    end


end
