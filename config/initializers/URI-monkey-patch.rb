## -*- coding: utf-8 -*-
## The following should prevent an ArgumentError "invalid %-encoding (...%)" exception from being raised for malformed URLs.
## To use this code simply drop this in your rails app initializers.
## See: https://github.com/rack/rack/issues/337
## Taken from: http://stackoverflow.com/a/11162317/1075006
#
#
##module URI
##
##  major, minor, patch = RUBY_VERSION.split('.').map { |v| v.to_i }
##
##  if major == 1 && minor <= 9
##    def self.decode_www_form_component(str, enc=nil)
##      if TBLDECWWWCOMP_.empty?
##        tbl = {}
##        256.times do |i|
##          h, l = i>>4, i&15
##          tbl['%%%X%X' % [h, l]] = i.chr
##          tbl['%%%x%X' % [h, l]] = i.chr
##          tbl['%%%X%x' % [h, l]] = i.chr
##          tbl['%%%x%x' % [h, l]] = i.chr
##        end
##        tbl['+'] = ' '
##        begin
##          TBLDECWWWCOMP_.replace(tbl)
##          TBLDECWWWCOMP_.freeze
##        rescue
##        end
##      end
##      str = str.gsub(/%(?![0-9a-fA-F]{2})/, "%25")
##      str.gsub(/\+|%[0-9a-fA-F]{2}/) {|m| TBLDECWWWCOMP_[m]}
##    end
##  end
##
##end
#
#
#start_time = "2013-01-09 10:30:00"
#end_time = "2013-01-18 09:45:00"
#
#working_time("2012-12-28 10:30:00", "2013-01-05 09:45:00")
#next_working_time("2013-01-05 09:45:00", 90)
#
#
#def next_working_time(time, duration = 0)
#  if time.is_a?(String)
#    time = Time.strptime(time, '%Y-%m-%d %T')
#  end
#
#  #暂时用到的一些变量
#  #########################################################
#  calendar_items_str = "{2012 => {12 => [28,29,30,31]},2013 =>{1 => [1, 2, 3, 4, 5, 6, 7, 8, 9], 2 => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] } }"
#
#  calendar_items = []
#
#  item1 = {}
#  item1[:calendar_obj]  = eval(calendar_items_str)
#  item1[:start_at] = "08:00"
#  item1[:end_at] = "12:00"
#  calendar_items << item1
#
#  item2 = {}
#  item2[:calendar_obj]  = eval(calendar_items_str)
#  item2[:start_at] = "14:00"
#  item2[:end_at] = "18:00"
#  calendar_items << item2
#  #########################################################
#
#  duration_seconds = duration * 60
#
#  next_working_time_at(time, duration_seconds, calendar_items)
#end
#
#def next_working_time_at(time, duration = 0, calendar_items=[])
#  unless duration > 0
#    return time
#  end
#
#  year, month, day = time.year, time.month, time.day
#
#  schedule_days = {}
#
#  calendar_items.each do |item|
#    calendar_obj = item[:calendar_obj]
#    if calendar_obj and calendar_obj[year] && calendar_obj[year][month] && calendar_obj[year][month].include?(day)
#      schedule_days[day] ||= []
#      schedule_days[day] << item
#    end
#  end
#
#  work_seconds = 0
#
#  puts "=============#{schedule_days.size}=============="
#
#  if schedule_days[day].any?
#    schedule_days[day].each do |item|
#      item_option = format_item_time(item[:start_at], item[:end_at], "#{year}-#{month}-#{day}")
#
#      puts "===============#{work_seconds}=============="
#      #时间不超出班次范围给予计算
#      if item_option[:start_at] < time && item_option[:end_at] > time
#        work_seconds += calculate_minutes(time, (time + duration), item_option)
#
#        if work_seconds < duration
#          time = item[:end_at]
#          duration = duration - work_seconds
#        end
#      end
#    end
#  else
#    time = time + 1.day
#  end
#
#  if work_seconds < duration
#    time = next_working_time_at(time, duration, calendar_items)
#  else
#    time = time + duration
#  end
#
#  time
#end
#
#
#
#def working_time(start_time, end_time)
#  if start_time.is_a?(String)
#     start_time = Time.strptime(start_time, '%Y-%m-%d %T')
#  end
#
#  if end_time.is_a?(String)
#    end_time = Time.strptime(end_time, '%Y-%m-%d %T')
#  end
#
#
#  if start_time > end_time
#    return 0
#  end
#
#  #暂时用到的一些变量
#  #########################################################
#  calendar_items_str = "{2012 => {12 => [28,29,30,31]},2013 =>{1 => [1, 2, 3, 4, 5, 6, 7, 8, 9], 2 => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] } }"
#  calendar_items = eval(calendar_items_str)
#
#  items = []
#  item1 = {}
#  item1[:start_at] = "08:00"
#  item1[:end_at] = "12:00"
#  items << item1
#
#  item2 = {}
#  item2[:start_at] = "14:00"
#  item2[:end_at] = "18:00"
#  items << item2
#
#  #########################################################
#
#  total_work_time = 0
#
#  end_year = end_time.year
#  end_month = end_time.month
#  end_day = end_time.day
#  end_hour = end_time.hour
#  end_minute = end_time.min
#
#  items.each do |item|
#    current_start_time = start_time.dup
#
#    while current_start_time <= end_time
#      start_year = current_start_time.year
#      start_month = current_start_time.month
#
#      if calendar_items[start_year] && calendar_items[start_year][start_month]
#        start_day = current_start_time.day
#
#        item_option = format_item_time(item[:start_at], item[:end_at])
#        if start_year.eql?(end_year) && start_month.eql?(end_month) && start_day.eql?(end_day)
#          current_end_hour = end_hour
#          current_end_minute = end_minute
#        else
#          current_end_hour = item_option[:end_at].hour
#          current_end_minute = item_option[:start_at].min
#        end
#
#        days = calendar_items[start_year][start_month]
#
#        if days.include?(start_day)
#          start_hour = current_start_time.hour
#          start_minute = current_start_time.min
#
#          start_hour_minute = format_time(start_hour, start_minute)
#          end_hour_minute = format_time(current_end_hour, current_end_minute)
#
#          total_work_time += calculate_minutes(start_hour_minute, end_hour_minute , item_option)
#        end
#
#        #将start_time的时间设置到班次开始时间
#        current_start_time = Time.parse("#{item_option[:start_at].hour}:#{item_option[:start_at].min}", current_start_time)
#        current_start_time += 1.day
#      end
#    end
#  end
#
#  total_work_time
#end
#
##获取指定班次的时间
#def calculate_minutes(start_hour_minute, end_hour_minute, item)
#  item_start = item[:start_at]
#  item_end = item[:end_at]
#
#  if start_hour_minute < item_start
#    start_hour_minute = item_start
#  end
#
#  if end_hour_minute > item_end
#    end_hour_minute = item_end
#  end
#
#  end_hour_minute - start_hour_minute
#end
#
##将分钟和小时用固定的时间年月日进行格式化，便于比较操作
#def format_time(hour, minute, format_date_str = "2013-01-01")
#  format_date_str = format_date_str + " #{hour}:#{minute}:00"
#  Time.strptime(format_date_str, '%Y-%m-%d %T')
#end
#
#def format_item_time(item_start, item_end, format_date_str= "2013-01-01")
#  item_option = {}
#  item_option[:start_at] = Time.strptime("#{format_date_str} #{item_start}:00", '%Y-%m-%d %T')
#  item_option[:end_at] = Time.strptime("#{format_date_str} #{item_end}:00", '%Y-%m-%d %T')
#  item_option
#end