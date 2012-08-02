class Irm::ReportTrigger < ActiveRecord::Base
  set_table_name :irm_report_triggers
  attr_accessor :receiver_str

  after_save :setup_schedule

  has_many :report_schedules,:dependent => :destroy
  has_many :report_receivers,:dependent => :destroy
  belongs_to :report

  validates_uniqueness_of :report_id
  validates_presence_of :report_id,:start_at,:end_at,:person_id

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  #添加报表可见人员
  def create_receiver_from_str
    if(!self.receiver_type.eql?("CHOOSE_STAFF"))
      self.receiver_str = ""
    end
    return unless self.receiver_str
    str_values = self.receiver_str.split(",").delete_if{|i| !i.present?}
    exists_values = Irm::ReportReceiver.where(:report_trigger_id=>self.id)
    exists_values.each do |value|
      if str_values.include?("#{value.receiver_type}##{value.receiver_id}")
        str_values.delete("#{value.receiver_type}##{value.receiver_id}")
      else
        value.destroy
      end

    end

    str_values.each do |value_str|
      next unless value_str.strip.present?
      value = value_str.strip.split("#")
      self.report_receivers.create(:receiver_type=>value[0],:receiver_id=>value[1])
    end
  end


  def get_receiver_str
    return @get_receiver_str if @get_receiver_str
    @get_receiver_str||=receiver_str
    @get_receiver_str||= Irm::ReportReceiver.where(:report_trigger_id=>self.id).collect{|value| "#{value.receiver_type}##{value.receiver_id}"}.join(",")
  end

  def receiver_person_ids
    if(!self.receiver_type.eql?("CHOOSE_STAFF"))
      return [self.created_by]
    end

    person_ids = Irm::ReportReceiver.where(:report_trigger_id=>self.id).query_person_ids.collect{|i| i[:person_id]}
    person_ids.uniq!
    person_ids
  end

  def time_mode_obj
    return @time_mode_obj if @time_mode_obj
    @time_mode_obj =  prepare_time_mode
  end

  def to_rrule_hash
    mode_obj = self.time_mode_obj
    rrule_hash = {:freq=>mode_obj[:freq]}
    case rrule_hash[:freq]
      when "DAILY"
        if("EVERYDAY".eql?(mode_obj[:daily][:type]))
          rrule_hash.merge!(:byday=>["MO","TU","WE","TH","FR"])
          rrule_hash.merge!(:freq=>"WEEKLY")
        else
          if(mode_obj[:daily][:interval].present?&&mode_obj[:daily][:interval].scan(/\D/).length<1)
            rrule_hash.merge!(:interval=>mode_obj[:daily][:interval].to_i)
          else
            raise "error"
          end
        end
      when "WEEKLY"
        if(mode_obj[:weekly][:interval].present?&&mode_obj[:weekly][:interval].scan(/\D/).length<1)
          rrule_hash.merge!(:interval=>mode_obj[:weekly][:interval].to_i)
        else
          raise "error"
        end
        if(mode_obj[:weekly][:days].length>0)
          rrule_hash.merge!(:byday=>mode_obj[:weekly][:days])
        else
          raise "error"
        end
      when "MONTHLY"
        if("DAY".eql?(mode_obj[:monthly][:type]))
          if(mode_obj[:monthly][:day][:interval].present?&&mode_obj[:monthly][:day][:interval].scan(/\D/).length<1)
            rrule_hash.merge!(:interval=>mode_obj[:monthly][:day][:interval].to_i)
          else
            raise "error"
          end
          if(mode_obj[:monthly][:day][:dayno].to_i==1)
            rrule_hash.merge!(:bymonthday=>[mode_obj[:monthly][:day][:dayno].to_i])
          else
            rrule_hash.merge!(:bymonthday=>[mode_obj[:monthly][:day][:dayno].to_i,1000])
          end
        else
          if(mode_obj[:monthly][:week][:interval].present?&&mode_obj[:monthly][:week][:interval].scan(/\D/).length<1)
            rrule_hash.merge!(:interval=>mode_obj[:monthly][:week][:interval].to_i)
          else
            raise "error"
          end
          rrule_hash.merge!(:bysetpos=>mode_obj[:monthly][:week][:weekno].to_i)
          rrule_hash.merge!(:byday=>mode_obj[:monthly][:week][:weekday])
        end
    end
  end

  # 计算2天内存在的执行时间
  def schedule_in_days(days=2,now = DateTime.now.change(:hour=>0,:min=>0,:sec=>0))
    # 计算开始时间与结束时间
    start_date =  self.start_at.to_datetime
    if now > start_date
      start_date = now
    end
    end_date = Time.now.change(:hour=>0,:min=>0,:sec=>0)+days.days
    if end_date > self.end_at.to_datetime
      end_date = self.end_at.to_datetime
    end
    # 取得rrule hash字符串
    rrule_hash =  self.to_rrule_hash
    rrule_i = RiCal::PropertyValue::RecurrenceRule.new(nil, rrule_hash.merge(:until =>end_date))

    # 为了取得今天开始两天内的有效执行计划需要将开始日期提前一天
    default_start_date = start_date-1.days
    # 如果是间隔大于1类型的执行计划需要重新调整开始日期
    if rrule_hash[:interval]&&rrule_hash[:interval]>1
      case rrule_hash[:freq]
        when "DAILY"
          default_start_date = self.start_at.to_datetime-rrule_hash[:interval].days
        when "WEEKLY"
          default_start_date = self.start_at.to_datetime-rrule_hash[:interval].weeks
        when "MONTHLY"
          default_start_date = self.start_at.to_datetime-rrule_hash[:interval].months
      end
    end

    default_start_time = RiCal::PropertyValue::DateTime.new(nil, :value =>default_start_date)
    component = Struct.new(:default_start_time, :default_duration)
    component_instance = component.new(default_start_time,nil)
    enum = rrule_i.enumerator(component_instance)
    occurrences = []
    while 1 do
      occurrence = enum.next_occurrence
      if occurrence.nil?
          break
      end
      occurrence_datetime = occurrence.dtstart.to_datetime
      occurrence_datetime = occurrence_datetime.change(:hour=>self.start_time.hour,:min=>self.start_time.min,:sec=>self.start_time.sec)
      occurrences << occurrence_datetime  if occurrence_datetime>start_date&&occurrence_datetime>DateTime.now
    end
    occurrences
  end
  # 同步两天要执行的任务
  def sync_schedule
    schedule_datetimes = schedule_in_days
    trigger_id = self.id
    schedule_datetimes.each do |t|
      rs = Irm::ReportSchedule.where(:report_trigger_id=>trigger_id,:run_at_str=>t.to_i.to_s).first
      unless rs
        Irm::ReportSchedule.create(:report_trigger_id=>trigger_id,:run_at=>t)
      end
    end
  end

  # 添理过时的schedule
  def clean_schedule
    Irm::ReportSchedule.where(:report_trigger_id=>self.id,:run_status=>"PENDING").delete_all
  end

  private
  def setup_schedule
    clean_schedule
    sync_schedule
  end
  def prepare_time_mode
    if self.time_mode.present?
      return YAML.load(self.time_mode)
    else
     {
      :freq=>"DAILY",
      :daily=>{:type=>"BYDAY", :interval=>"1"},
      :weekly=>{:interval=>"1", :days=>["MO"]},
      :monthly=>{:type=>"WEEK",:day=>{ :interval=>"1", :dayno=>"1"}, :week=>{:interval=>"1", :weekno=>"1", :weekday=>"MO"}}
     }
    end
  end
end
