module Irm
  class ConvertTime
    class << self
      #返回所有的日期常量
      def date_str_arr
        date_arr = ["YESTERDAY","TODAY","TOMORROW","CURY","PREVY","PREV2Y","NEXTY","LAST7",
                    "PREVCURY","PREVCUR2Y","CURNEXTY","CURRENTQ","PREVQ","NEXTQ","NEXT7",
                    "CURPREVQ","CURNEXTQ","CURNEXT3Q","LASTMONTH","CURMONTH","NEXTMONTH",
                    "LASTTHISMONTH","NEXTTHISMONTH","LASTWEEK","CURWEEK","NEXTWEEK"]
        (30..120).step(30).each do |num|
          date_arr << "LAST#{num}"
          date_arr << "NEXT#{num}"
        end
        date_arr
      end

      def convert(time_text)
        today = Date.today #.strftime('%Y-%m-%d')
        time_during = {}
        case time_text.to_s.upcase
          ##########################日历天##########################
          when "YESTERDAY"
            time_during[:from] = date_format(today -1)
            time_during[:to] = date_format(today -1)
          when "TODAY"
            time_during[:from] = date_format(today)
            time_during[:to] = date_format(today)
          when "TOMORROW"
            time_during[:from] = date_format(today + 1)
            time_during[:to] = date_format(today + 1)
          #过去n天
          when /LAST\d+/
            time_during[:from] = date_format(today - time_text.scan(/\d+/)[0].to_i)
            time_during[:to] = date_format(today)
          #未来n天
          when /NEXT\d+/
            time_during[:from] = date_format(today)
            time_during[:to] = date_format(today + time_text.scan(/\d+/)[0].to_i)
          ##########################日历年度##########################
          when "CURY"
            time_during[:from] = date_format(today.beginning_of_year)
            time_during[:to] = date_format(today.end_of_year)
          #上一日历年度
          when "PREVY"
            time_during[:from] = date_format(today.prev_year.beginning_of_year)
            time_during[:to] = date_format(today.prev_year.end_of_year)
          when "PREV2Y"
            time_during[:from] = date_format(today.prev_year.prev_year.beginning_of_year)
            time_during[:to] = date_format(today.prev_year.end_of_year)
          #两个日历年度之前
          when "AGO2Y"
            time_during[:from] = date_format(today.years_ago(2).beginning_of_year)
            time_during[:to] = date_format(today.years_ago(2).end_of_year)
          #下一日历年度
          when "NEXTY"
            time_during[:from] = date_format(today.next_year.beginning_of_year)
            time_during[:to] = date_format(today.next_year.end_of_year)
          #当前和上一个日历年度
          when "PREVCURY"
            time_during[:from] = date_format(today.prev_year.beginning_of_year)
            time_during[:to] = date_format(today.end_of_year)
          #当前和前两个
          when "PREVCUR2Y"
            time_during[:from] = date_format(today.years_ago(2).beginning_of_year)
            time_during[:to] = date_format(today.end_of_year)
          when "CURNEXTY"
            time_during[:from] = date_format(today.beginning_of_year)
            time_during[:to] = date_format(today.next_year.end_of_year)
          ##########################日历季度##########################
          when "CURRENTQ"
            time_during[:from] = date_format(today.beginning_of_quarter)
            time_during[:to] = date_format(today.end_of_quarter)
          #上一季度
          when "PREVQ"
            time_during[:from] = date_format(today.months_ago(3).beginning_of_quarter)
            time_during[:to] = date_format(today.months_ago(3).end_of_quarter)
          #下一季度
          when "NEXTQ"
            time_during[:from] = date_format(today.months_since(3).beginning_of_quarter)
            time_during[:to] = date_format(today.months_since(3).end_of_quarter)
          #当前和上一个季度
          when "CURPREVQ"
            time_during[:from] = date_format(today.months_ago(3).beginning_of_quarter)
            time_during[:to] = date_format(today.end_of_quarter)
          #当前和下一个季度
          when "CURNEXTQ"
            time_during[:from] = date_format(today.beginning_of_quarter)
            time_during[:to] = date_format(today.months_since(3).end_of_quarter)
          #当前和未来三个日历季度
          when "CURNEXT3Q"
            time_during[:from] = date_format(today.beginning_of_quarter)
            time_during[:to] = date_format(today.months_since(9).end_of_quarter)

          ##########################日历月##########################
          when "LASTMONTH"
            time_during[:from] = date_format(today.prev_month.beginning_of_month)
            time_during[:to] = date_format(today.prev_month.end_of_month)
          when "CURMONTH"
            time_during[:from] = date_format(today.beginning_of_month)
            time_during[:to] = date_format(today.end_of_month)
          when "NEXTMONTH"
            time_during[:from] = date_format(today.next_month.beginning_of_month)
            time_during[:to] = date_format(today.next_month.end_of_month)
          #当前月和上一个月
          when "LASTTHISMONTH"
            time_during[:from] = date_format(today.prev_month.beginning_of_month)
            time_during[:to] = date_format(today.end_of_month)
          when "NEXTTHISMONTH"
            time_during[:from] = date_format(today.beginning_of_month)
            time_during[:to] = date_format(today.next_month.end_of_month)

          ##########################日历星期##########################
          when "LASTWEEK"
            time_during[:from] = date_format(today.prev_week.beginning_of_week)
            time_during[:to] = date_format(today.prev_week.end_of_week)
          when "CURWEEK"
            time_during[:from] = date_format(today.beginning_of_week)
            time_during[:to] = date_format(today.end_of_week)
          when "NEXTWEEK"
            time_during[:from] = date_format(today.next_week.beginning_of_week)
            time_during[:to] = date_format(today.next_week.end_of_week)
        end
        time_during
      end

      def date_format(time_or_date)
        time_or_date.strftime('%Y-%m-%d') if time_or_date
      end
    end
    #module_function :date_str_arr, :convert,:date_format
  end
end