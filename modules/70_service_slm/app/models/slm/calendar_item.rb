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

  scope :with_start_and_end, lambda{|start_at, end_at|
    where("start_at=? AND end_at=?", start_at, end_at)
  }

  scope :with_years, lambda { |years|
    where("calendar_year IN(?)", years)
  }

  scope :ordered, lambda {
    order("start_at ASC, end_at ASC")
  }

  scope :with_active, where("deadline > ?", Time.now)

  scope :without_all, where("relation_type <>?", "ALL")

  scope :order_by_type, order("relation_type ASC")

  def time_mode_obj
    return @time_mode_obj if @time_mode_obj
    @time_mode_obj = prepare_time_mode
  end

  #Slm::CalendarItem.available_items('004m000B4lduu8duSzuvDc')
  #{"2013" => {1 => {"08_00_12_00" => [1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 15, 16, 17, 18, 21, 22, 23, 24, 25, 28, 29, 30, 31],
  #                  "14_00_18_00" => [1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 15, 16, 17, 18, 21, 22, 23, 24, 25, 28, 29, 30, 31]},
  #            2 => {"08_00_12_00" => [1, 4, 5, 6, 7, 8, 11, 12, 13, 14, 15, 18, 19, 20, 21, 22, 25, 26, 27, 28],
  #                  "14_00_18_00" => [1, 4, 5, 6, 7, 8, 11, 12, 13, 14, 15, 18, 19, 20, 21, 22, 25, 26, 27, 28]},
  #            3 => {"08_00_12_00" => [1, 4, 5, 6, 7, 8, 11, 12, 13, 14, 15, 18, 19, 20, 21, 22, 25, 26, 27, 28, 29],
  #                  "14_00_18_00" => [1, 4, 5, 6, 7, 8, 11, 12, 13, 14, 15, 18, 19, 20, 21, 22, 25, 26, 27, 28, 29]},
  #            4 => {"08_00_12_00" => [1, 2, 3, 4, 5, 8, 9, 10, 11, 12, 15, 16, 17, 18, 19, 22, 23, 24, 25, 26, 29, 30],
  #                  "14_00_18_00" => [1, 2, 3, 4, 5, 8, 9, 10, 11, 12, 15, 16, 17, 18, 19, 22, 23, 24, 25, 26, 29, 30]},
  #            5 => {"08_00_12_00" => [1, 2, 3, 6, 7, 8, 9, 10, 13, 14, 15, 16, 17, 20, 21, 22, 23, 24, 27, 28, 29, 30, 31],
  #                  "14_00_18_00" => [1, 2, 3, 6, 7, 8, 9, 10, 13, 14, 15, 16, 17, 20, 21, 22, 23, 24, 27, 28, 29, 30, 31]},
  #            6 => {"08_00_12_00" => [3, 4, 5, 6, 7, 10, 11, 12, 13, 14, 17, 18, 19, 20, 21, 24, 25, 26, 27, 28],
  #                  "14_00_18_00" => [3, 4, 5, 6, 7, 10, 11, 12, 13, 14, 17, 18, 19, 20, 21, 24, 25, 26, 27, 28]},
  #            7 => {"08_00_12_00" => [1, 2, 3, 4, 5, 8, 9, 10, 11, 12, 15, 16, 17, 18, 19, 22, 23, 24, 25, 26, 29, 30, 31],
  #                  "14_00_18_00" => [1, 2, 3, 4, 5, 8, 9, 10, 11, 12, 15, 16, 17, 18, 19, 22, 23, 24, 25, 26, 29, 30, 31]},
  #            8 => {"08_00_12_00" => [1, 2, 5, 6, 7, 8, 9, 12, 13, 14, 15, 16, 19, 20, 21, 22, 23, 26, 27, 28, 29, 30],
  #                  "14_00_18_00" => [1, 2, 5, 6, 7, 8, 9, 12, 13, 14, 15, 16, 19, 20, 21, 22, 23, 26, 27, 28, 29, 30]},
  #            9 => {"08_00_12_00" => [2, 3, 4, 5, 6, 9, 10, 11, 12, 13, 16, 17, 18, 19, 20, 23, 24, 25, 26, 27, 30],
  #                  "14_00_18_00" => [2, 3, 4, 5, 6, 9, 10, 11, 12, 13, 16, 17, 18, 19, 20, 23, 24, 25, 26, 27, 30]},
  #            10 => {"08_00_12_00" => [1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 15, 16, 17, 18, 21, 22, 23, 24, 25, 28, 29, 30, 31],
  #                   "14_00_18_00" => [1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 15, 16, 17, 18, 21, 22, 23, 24, 25, 28, 29, 30, 31]},
  #            11 => {"08_00_12_00" => [1, 4, 5, 6, 7, 8, 11, 12, 13, 14, 15, 18, 19, 20, 21, 22, 25, 26, 27, 28, 29],
  #                   "14_00_18_00" => [1, 4, 5, 6, 7, 8, 11, 12, 13, 14, 15, 18, 19, 20, 21, 22, 25, 26, 27, 28, 29]},
  #            12 => {"08_00_12_00" => [2, 3, 4, 5, 6, 9, 10, 11, 12, 13, 16, 17, 18, 19, 20, 23, 24, 25, 26, 27, 30, 31],
  #                   "14_00_18_00" => [2, 3, 4, 5, 6, 9, 10, 11, 12, 13, 16, 17, 18, 19, 20, 23, 24, 25, 26, 27, 30, 31]}
  #            }
  #}

  def self.available_items(calendar_id)
    calendar_items = Slm::CalendarItem.where("calendar_id=?", calendar_id)
    calendar_item_obj = {}
    calendar_items.each do |item|
      calendar_item_obj[item.calendar_year] ||= {}
      month_obj = eval(item[:calendar_obj])
      month_obj.each do |month, days|
        calendar_item_obj[item.calendar_year][month] ||= {}
        start_end_key = "#{item[:start_at].gsub(/:/, '_')}to#{item[:end_at].gsub(/:/, '_')}"
        calendar_item_obj[item.calendar_year][month][start_end_key] = days
      end
    end
    calendar_item_obj
  end

  def year_month_day_schedules(available_items, year, month, day)
    now = Time.now
    start_at_time = Time.parse("#{self.start_at}", now)
    end_at_time = Time.parse("#{self.end_at}", now)

    schedules = []

    if available_items[year.to_s] && available_items[year.to_s][month]
      available_items[year.to_s][month].each do |start_end, days|
        if days.include?(day)
          current_start_end_at = start_end.gsub(/_/,":").split('to')
          current_start_at_time = Time.parse("#{current_start_end_at[0]}", now)
          current_end_at_time = Time.parse("#{current_start_end_at[1]}", now)
          schedules << [current_start_at_time, current_end_at_time]
        end
      end
    end
    new_schedules = merge_duration(schedules << [start_at_time, end_at_time])
    schedules.each do |schedule|
      unless new_schedules.include?(schedule)
        s_start_at, s_end_at = "#{'%02d' % schedule[0].hour}:#{'%02d' % schedule[0].min}", "#{ '%02d' % schedule[1].hour}:#{'%02d' % schedule[1].min}"
        s_item = Slm::CalendarItem.with_calendar(self.calendar_id).with_years([year]).with_start_and_end(s_start_at, s_end_at).first
        if s_item
          month_obj = eval(s_item[:calendar_obj])

          month_obj[month].delete_if{|i| i == day}
          s_item.calendar_obj = month_obj.to_s
          s_item.save
        end
      end
    end
    new_schedules - schedules
  end

  def merge_duration(durations)
    new_durations = []

    durations.each do |start_end_at|
      d_start_at = start_end_at[0]
      d_end_at = start_end_at[1]

      durations.each do |duration|
        if duration == start_end_at
          next
        end
        current_start = duration[0]
        current_end = duration[1]

        new_start_at, new_end_at, is_new = new_start_and_end(d_start_at, d_end_at, current_start, current_end)
        if is_new
          new_durations.delete_if{|i| i == [d_start_at, d_end_at] || i == [current_start, current_end]}
          new_durations << [new_start_at, new_end_at] unless new_durations.include?([new_start_at, new_end_at])
        else
          new_durations << [new_start_at, new_end_at] unless new_durations.include?([new_start_at, new_end_at])
          new_durations << [current_start, current_end] unless new_durations.include?([current_start, current_end])
        end
        d_start_at = new_start_at
        d_end_at = new_end_at
      end
    end
    new_durations
  end

  def new_start_and_end(start_at, end_at, current_start, current_end)
    new_start_at = start_at
    new_end_at = end_at
    new_duration = false

    #判断是否有交集,当有交集的时候才进行合并
    unless current_end < start_at || end_at < current_start
      new_duration = true
      if start_at < current_start
        new_start_at = start_at
        if end_at < current_end
          new_end_at = current_end
        else
          new_end_at = end_at
        end
      else
        new_start_at = current_start
        if end_at < current_end
          new_end_at = current_end
        else
          new_end_at = end_at
        end
      end
    end
    [new_start_at, new_end_at, new_duration]
  end

  def hand_calendar_item
    available_items = Slm::CalendarItem.available_items(self.calendar_id)

    self.start_time = Time.strptime("#{self.start_time} 00:00:00", '%Y-%m-%d %T')
    if self.end_time.blank?
      self.end_time = self.start_time
    end
    self.end_time = Time.strptime("#{self.end_time} 00:00:00", '%Y-%m-%d %T')

    if self.start_time <= self.end_time #and self.start_time.day != self.end_time.day
      years_obj = {}
      if self.weeks_str.present?
        week_days = self.weeks_str
      else
        week_days = ["1", "2", "3", "4", "5", "6", "0"]
      end

      while start_time <= end_time
        year, month, day, wday = start_time.year, start_time.month, start_time.day, start_time.wday
        unless week_days.include?(wday)
          next
        end
        years_obj[year] ||= {}
        start_end_key = "#{self.start_at.gsub(/:/, '_')}to#{self.end_at.gsub(/:/, '_')}"
        #该班次已经存在
        new_start_end_ats = year_month_day_schedules(available_items, year, month, day)
        if new_start_end_ats.any?
          puts "============11================"
          month_obj ||= {}
          new_start_end_ats.each do |new_start_end_at|
            new_start_at, new_end_at = "#{'%02d' % new_start_end_at[0].hour}:#{'%02d' % new_start_end_at[0].min}", "#{'%02d' % new_start_end_at[1].hour}:#{'%02d' % new_start_end_at[1].min}"
            new_start_end_key = "#{new_start_at.gsub(/:/, '_')}to#{new_end_at.gsub(/:/, '_')}"
            if available_items[year.to_s] && available_items[year.to_s][month] && available_items[year.to_s][month][new_start_end_key]
              month_obj[month] = available_items[year.to_s][month][new_start_end_key]
              unless available_items[year.to_s][month][new_start_end_key].include?(day)
                if week_days.include?(wday.to_s)
                  month_obj[month] << day
                  available_items[year.to_s][month][new_start_end_key] << day unless available_items[year.to_s][month][new_start_end_key].include?(day)
                end

              end
            else
              available_items[year.to_s] ||= {}
              available_items[year.to_s][month] ||= {}
              available_items[year.to_s][month][new_start_end_key] ||= []

              month_obj[month] ||= []
              if week_days.include?(wday.to_s)
                month_obj[month] << day
                available_items[year.to_s][month][new_start_end_key] << day unless available_items[year.to_s][month][new_start_end_key].include?(day)
              end
            end
            save_calendar_item(self.calendar_id, new_start_at, new_end_at, month_obj, year)
          end
        elsif available_items[year.to_s] && available_items[year.to_s][month] && available_items[year.to_s][month][start_end_key]
          puts "============22================"
          years_obj[year][month] = available_items[year.to_s][month][start_end_key]
          #如果该天不在班次中直接加到班次中
          unless available_items[year.to_s][month][start_end_key].include?(day)
            if week_days.include?(wday.to_s)
              years_obj[year][month] << day
              available_items[year.to_s][month][start_end_key] << day unless available_items[year.to_s][month][start_end_key].include?(day)
            end
          end
        else
          puts "============33================"
          available_items[year.to_s] ||= {}
          available_items[year.to_s][month] ||= {}
          available_items[year.to_s][month][start_end_key] ||= []

          years_obj[year][month] ||= []

          if week_days.include?(wday.to_s)
            years_obj[year][month] << day
            available_items[year.to_s][month][start_end_key] << day unless available_items[year.to_s][month][start_end_key].include?(day)
          end

        end

        #if !new_start_end_ats.any? && available_items[year.to_s] && available_items[year.to_s][month] && available_items[year.to_s][month][start_end_key]
        #  puts "============11================"
        #  years_obj[year][month] = available_items[year.to_s][month][start_end_key]
        #
        #  #如果该天不在班次中直接加到班次中
        #  unless available_items[year.to_s][month][start_end_key].include?(day)
        #    years_obj[year][month] << day if week_days.include?(wday.to_s)
        #  end
        #else
        #  #new_start_end_ats = year_month_day_schedules(available_items, year, month, day)
        #  if new_start_end_ats.any? #找出该天所包含的班次，如果有重叠的部分进行合并
        #    puts "============22================"
        #    month_obj ||= {}
        #    new_start_end_ats.each do |new_start_end_at|
        #      new_start_at, new_end_at = "#{'%02d' % new_start_end_at[0].hour}:#{'%02d' % new_start_end_at[0].min}", "#{'%02d' % new_start_end_at[1].hour}:#{'%02d' % new_start_end_at[1].min}"
        #      new_start_end_key = "#{new_start_at.gsub(/:/, '_')}to#{new_end_at.gsub(/:/, '_')}"
        #      if available_items[year.to_s] && available_items[year.to_s][month] && available_items[year.to_s][month][new_start_end_key]
        #        month_obj[month] = available_items[year.to_s][month][new_start_end_key]
        #        unless available_items[year.to_s][month][new_start_end_key].include?(day)
        #          if week_days.include?(wday.to_s)
        #            month_obj[month] << day
        #            available_items[year.to_s][month][new_start_end_key] << day unless available_items[year.to_s][month][new_start_end_key].include?(day)
        #          end
        #
        #        end
        #      else
        #        available_items[year.to_s] ||= {}
        #        available_items[year.to_s][month] ||= {}
        #        available_items[year.to_s][month][new_start_end_key] ||= []
        #
        #        month_obj[month] ||= []
        #        if week_days.include?(wday.to_s)
        #          month_obj[month] << day
        #          available_items[year.to_s][month][new_start_end_key] << day unless available_items[year.to_s][month][new_start_end_key].include?(day)
        #        end
        #      end
        #      save_calendar_item(self.calendar_id, new_start_at, new_end_at, month_obj, year)
        #    end
        #  else
        #    puts "============33================"
        #    years_obj[year][month] ||= []
        #    years_obj[year][month] << day if week_days.include?(wday.to_s)
        #  end
        #end

        self.start_time = self.start_time + 1.day
      end

      years_obj.each do |year, month_obj|
        save_calendar_item(self.calendar_id, self.start_at, self.end_at, month_obj, year)
      end if years_obj.any?
    end

  end


  def save_calendar_item(s_calendar_id, s_start_at, s_end_at, s_month_obj, s_year)
    year_start_end_item = Slm::CalendarItem.where("calendar_id=? AND calendar_year=? AND start_at=? AND end_at=?", s_calendar_id, s_year, s_start_at, s_end_at).first
    if s_month_obj and s_month_obj.any?
      if year_start_end_item.present?
        year_start_end_item.calendar_obj = s_month_obj.to_s
        year_start_end_item.save
      else
        Slm::CalendarItem.create(:start_at => s_start_at,
                                 :end_at => s_end_at,
                                 :calendar_id => s_calendar_id,
                                 :calendar_obj => s_month_obj.to_s,
                                 :calendar_year => s_year)
      end
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
