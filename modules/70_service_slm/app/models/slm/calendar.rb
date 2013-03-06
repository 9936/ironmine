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

  #计算当前工作日历下的工作时间
  def working_time(start_time, end_time)
    #获取所有为包含的规则
    include_items = []
    exclude_items = []
    calendar_items.each do |item|
      if item.relation_type.eql?('INCLUDE')
        include_items << item
      else
        exclude_items << item
      end
    end

    exclude_rules = []
    schedule_hash = {}
    exclude_rules.eachd do |item|
      exclude_rules << get_rules(item)
    end

    include_rules.each do |item|
      schedule_hash[item.id] ||= {}
      schedule_hash[item.id][:schedule] = IceCube::Schedule.new(item.start_at, {:end_time => item.end_at})
      schedule_hash[item.id][:duration] = item.end_at - item.start_at

      #将自身的规则进行添加
      schedule_hash[item.id][:schedule].add_recurrence_rule(get_rules(all_rule_item)[0])
      #处理排除的规则
      exclude_rules.each do |rule|
        schedule_hash[item.id][:schedule].add_exception_rule(rule)
      end
    end

    schedule_hash.each do |k, v|
      occurrences_array = v[:schedule].occurrences_between(st, et)
      puts ""
    end


  end

  def work_time(start_time, end_time)
    all_rule_item = nil
    other_rule_items = []
    calendar_items.each do |item|
      if item.relation_type.eql?('ALL')
        all_rule_item = item
      else
        other_rule_items << item
      end
    end

    if all_rule_item.present?
      #处理主规则
      schedule = IceCube::Schedule.new(all_start_time, {:end_time => all_end_time})
      schedule.add_recurrence_rule(get_rules(all_rule_item)[0])

      #处理其他的规则：包含或排除
      other_rule_items.each do |item|
        rules = get_rules(item)
        rules.each do |rule|
          if item.relation_type.eql?('INCLUDE')
            schedule.add_recurrence_rule(rule)
          else
            schedule.add_exception_rule(rule)
          end
        end
      end

      occurrences_array = schedule.occurrences_between(start_time, end_time)


      puts "=================#{occurrences_array}==============="
    else
      raise "there is no main rule in calendar #{self}"
    end
  end

  def get_rules(item)
    time_mode_obj = item.time_mode_obj
    freq_str = time_mode_obj[:freq]
    rules = []
    start_time = item.start_at
    end_time = item.end_at

    if freq_str.eql?('DAILY')
      interval = time_mode_obj[:daily][:interval]
      if item.relation_type.eql?('INCLUDE')
        rules << IceCube::Rule.daily(interval.to_i)
      else
        get_months_and_days(start_time, end_time, interval).each do |month, month_days|
          rules << IceCube::Rule.yearly.month_of_year(month).day_of_month(*month_days[:days])
        end
      end
    elsif freq_str.eql?('WEEKLY')
      week_days = time_mode_obj[:weekly][:days]
      interval = time_mode_obj[:weekly][:interval]
      days = get_weeks(week_days)
      if item.relation_type.eql?('INCLUDE')
        rules << IceCube::Rule.weekly(interval.to_i).day(*days)
      else
        get_months_and_days(start_time, end_time, interval).each do |month, month_days|
          rules << IceCube::Rule.yearly.month_of_year(month).day(*days).day_of_month(*month_days[:days])
        end
      end
    end
    rules
  end


  def get_weeks(week_days)
    weeks = []
    week_days.each do |week_day|
      case week_day
        when "MO"
          weeks << :monday
        when "TU"
          weeks << :tuesday
        when "WE"
          weeks << :wednesday
        when "TH"
          weeks << :thursday
        when "FR"
          weeks << :friday
        when "SA"
          weeks << :saturday
        when "SU"
          weeks << :sunday
        else
          ""
      end
    end
    weeks
  end

  def get_months_and_days(start_time, end_time, interval=1)
    months_and_days = {}
    if start_time.is_a?(Time) and end_time.is_a?(Time)
      while start_time < end_time
        month = start_time.month
        months_and_days[month] ||= {}
        months_and_days[month][:days] ||= []
        day = start_time.day
        months_and_days[month][:days] << day

        start_time = start_time + interval.to_i.day
      end
    end
    months_and_days
  end

  def month_and_day_and_hour(start_time, end_time)

  end

end
