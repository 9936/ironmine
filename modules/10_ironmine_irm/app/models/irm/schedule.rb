class Irm::Schedule < ActiveRecord::Base

  def self.get_working_time_duration(start_time, end_time)
    st = Time.strptime("#{start_time}", '%Y-%m-%d %T')
    et = Time.strptime("#{end_time}", '%Y-%m-%d %T')
    schedule_duration = 14400
    demo_date = Time.strptime("2013-01-30 08:00:00", '%Y-%m-%d %T')
    #8点-12点, duration = 4小时
    schedule = IceCube::Schedule.new(demo_date, :duration => schedule_duration)
    #每周一至周五循环
    rule = IceCube::Rule.weekly.day(:monday, :tuesday, :wednesday, :thursday, :friday)
    #=====================================================================================

    schedule.add_recurrence_rule rule
    occurrences_array = schedule.occurrences_between(st, et)

    if occurrences_array.size == 0
      return 0
    end

    t1 = 0
    if schedule.occurring_at?(st)
      t1 = (Time.strptime("#{schedule.next_occurrence(st - schedule_duration)}", '%Y-%m-%d %T') + schedule_duration) - st
    end

    t2 = 0
    if schedule.occurring_at?(et)
      t2 = et - Time.strptime("#{occurrences_array.last}", '%Y-%m-%d %T')
    end

    occurrences_array.pop if t2 != 0

    return_value_in_second = (occurrences_array.size * schedule_duration) + t1 + t2

    return return_value_in_second
  end

end