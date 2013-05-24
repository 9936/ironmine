class Gtd::Task < ActiveRecord::Base
  set_table_name :gtd_tasks

  attr_accessor :duration_day, :duration_hour, :duration_minute

  validates_presence_of :name ,:plan_start_at, :assigned_to, :access_type
  validates_presence_of :duration_day, :duration_hour, :duration_minute, :start_at, :end_at, :if => Proc.new { |i| i.repeat == 'Y' }
  validates_format_of :duration_day, :duration_hour, :duration_minute, :with => /\d+/, :if => Proc.new { |i| i.repeat == 'Y' }
  validates_presence_of :plan_end_at, :if => Proc.new { |i| i.repeat == 'N' }

  before_save :init_task
  after_save :create_member_from_str, :update_task_instances
  before_validation :transform_time
  after_find :untransform_time

  has_many :task_instances, :class_name => "Gtd::Task", :foreign_key => :parent_id, :dependent => :destroy
  belongs_to :notify_program, :foreign_key => :notify_program_id

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  attr_accessor :member_str
  has_many :task_members, :foreign_key => :task_id, :dependent => :destroy

  scope :with_all, lambda{
    select("#{table_name}.*").with_external_system(I18n.locale)
  }

  def self.tomorrow_tasks
    tomorrow = Time.now.change(:hour => 0, :min => 0, :sec => 0) + 1.day
    with_all.
        with_assigned_person.
        with_notify_program.
        query_instances_by_day(tomorrow)
  end

  scope :with_notify_program, lambda {
    joins("JOIN #{Gtd::NotifyProgram.table_name} np ON np.id = #{table_name}.notify_program_id").
        select("np.notify_type, np.wf_mail_alert_id, np.incident_request_hash")
  }

  scope :only_tasks, lambda {
    where("#{table_name}.parent_id IS NULL")
  }


  scope :with_assigned_person, lambda {
    joins("JOIN #{Irm::Person.table_name} p ON p.id = #{table_name}.assigned_to").
        select("p.full_name")
  }

  scope :with_assigned_me, lambda {
    where("#{table_name}.assigned_to=?", Irm::Person.current.id)
  }

  scope :with_external_system, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::ExternalSystem.view_name} external_system ON external_system.id = #{table_name}.external_system_id AND external_system.language = '#{language}'").
        select("external_system.system_name external_system_name")
  }


  scope :assigned_to, lambda{|person_id|
    where("#{table_name}.assigned_to = ?", person_id)
  }


  scope :query_instances_by_day, lambda{|date_time|
    where("#{table_name}.plan_start_at <? AND #{table_name}.plan_end_at >=? AND (#{table_name}.parent_id IS NOT NULL OR (#{table_name}.repeat='N' AND #{table_name}.parent_id IS NULL))", date_time + 1.day, date_time)
  }

  scope :with_rule_type, lambda{|rule_types|
    where(:rule_type => rule_types)
  }

  scope :with_status, lambda{|status|
    where(:execute_status => status)
  }

  scope :with_filter, lambda{|filter|
    #分派给我的
    if filter.eql?("zero")
      where(:assigned_to => Irm::Person.current.id)
    #我创建的
    elsif filter.eql?("one")
      where(:created_by => Irm::Person.current.id)
    #我参与的
    elsif filter.eql?("two")
      joins("JOIN #{Gtd::TaskMember.table_name} gtm ON (gtm.task_id=#{table_name}.id OR gtm.task_id = #{table_name}.parent_id)").
          joins("JOIN #{Irm::Person.relation_view_name} prv ON prv.source_type=gtm.member_type AND prv.source_id=gtm.member_id").
          where("prv.person_id=?", Irm::Person.current.id)
    #我分派的

    end
  }


  def update_task_instances
    Gtd::Task.delete_all("parent_id = '#{self.id}'")
    #self.task_instances.map(&:destroy)
    if self.repeat.eql?('Y')
      self.generate_task_instances(self.start_at + 1.month)
    end
  end

  #根据指定时间生成任务实例
  def generate_task_instances(end_time)
    #end_time必须要大于开始时间
    end_time = end_time.to_datetime

    start_date =  self.start_at.to_datetime
    end_date = self.end_at.to_datetime
    if end_time > end_date
      end_time = end_date
    elsif end_time < start_date
      return
    end
    occurrences = get_occurrences(start_date, end_time)

    #根据持续时间计算结束日期
    #start_time_arr = self.plan_start_at.strftime('%H:%M:%S').split(":")
    hour = self.plan_start_at.hour
    minute = self.plan_start_at.min
    second = self.plan_start_at.sec

    occurrences.each do |occurrence|
      occurrence = occurrence.change(:hour=> hour,:min => minute,:sec => second)
      occurrence_end = occurrence + self.duration_day.to_i.day + self.duration_hour.to_i.hour + self.duration_minute.to_i.minute

      task_instance = Gtd::Task.where(:parent_id => self.id, :start_at => occurrence, :end_at => occurrence_end).first
      unless task_instance.present?
        task_instance = Gtd::Task.new(self.attributes)
        #任务实例名称为任务名称加日期,如：工作周报2013-05-06
        task_instance.name = "#{self.name}#{occurrence.strftime('%Y-%m-%d')}"

        task_instance.parent_id = self.id
        task_instance.repeat = 'N'

        task_instance.plan_start_at = occurrence
        task_instance.plan_end_at = occurrence_end
        task_instance.start_at = nil
        task_instance.end_at = nil

        task_instance.save
      end
    end
  end

  def init_task
    #初始化任务状态
    if self.execute_status.blank?
      self.execute_status = "WAITING"
    end

    #初始化重复类型
    if self.repeat and self.repeat.eql?("Y")
      self.rule_type = self.time_mode_obj[:freq]
    elsif self.parent_id.present?
      self.rule = nil
    else
      self.rule = nil
      self.rule_type = nil
    end

    #初始化任务类型
    if self.parent_id.blank?
      self.task_type = "TASK"
    else
      self.task_type = "INSTANCE"
    end
  end

  def create_member_from_str
    if !self.member_type.eql?("MEMBER")
      self.member_str = ""
    end
    return unless self.member_str

    str_values = self.member_str.split(",").delete_if{|i| !i.present?}
    exists_values = Gtd::TaskMember.where(:task_id => self.id)
    exists_values.each do |value|
      if str_values.include?("#{value.member_type}##{value.member_id}")
        str_values.delete("#{value.member_type}##{value.member_id}")
      else
        value.destroy
      end
    end

    str_values.each do |value_str|
      next unless value_str.strip.present?
      value = value_str.strip.split("#")
      self.task_members.create(:member_type=>value[0],:member_id=>value[1])
    end
  end



  def get_member_str
    return @get_member_str if @get_member_str
    @get_member_str||=member_str
    @get_member_str||= Gtd::TaskMember.where(:task_id=>self.id).collect{|value| "#{value.member_type}##{value.member_id}"}.join(",")
  end

  def member_ids
    if(!self.member_type.eql?("MEMBER"))
      return [self.created_by]
    end

    person_ids = Gtd::TaskMember.where(:task_id=>self.id).query_person_ids.collect{|i| i[:person_id]}
    person_ids.uniq!
    person_ids
  end

  def time_mode_obj
    return @time_mode_obj if @time_mode_obj
    @time_mode_obj =  prepare_time_mode
  end

  #计算指定时间内的按照循环规则重复的时间
  def get_occurrences(start_time, end_time)
    start_date =  self.start_at.to_datetime
    end_date = self.end_at.to_datetime

    if start_time > end_date || end_time < start_date
      return []
    end

    if start_time > start_date && start_time <= end_date
      start_date = start_time
    end

    if end_time < end_date && end_time >= start_date
      end_date = end_time
    end

    if end_date > self.end_at.to_datetime
      end_date = self.end_at.to_datetime
    end
    #取得rrule hash字符串
    rrule_hash =  self.to_rrule_hash
    rrule_i = RiCal::PropertyValue::RecurrenceRule.new(nil, rrule_hash.merge(:until =>end_date))

    # 为了取得今天开始两天内的有效执行计划需要将开始日期提前一天
    default_start_date = start_date-1.days
    # 如果是间隔大于1类型的执行计划需要重新调整开始日期
    if rrule_hash[:interval]&&rrule_hash[:interval]>1
      case rrule_hash[:freq]
        when "DAILY"
          default_start_date = start_date-rrule_hash[:interval].days
        when "WEEKLY"
          default_start_date = start_date-rrule_hash[:interval].weeks
        when "MONTHLY"
          default_start_date = start_date-rrule_hash[:interval].months
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
      #occurrence_datetime = occurrence_datetime.change(:hour=>self.start_time.hour,:min=>self.start_time.min,:sec=>self.start_time.sec)
      occurrences << occurrence_datetime  if occurrence_datetime>= start_date# && occurrence_datetime>DateTime.now
    end
    occurrences
  end


  def to_rrule_hash
    mode_obj = self.time_mode_obj
    rrule_hash = {:freq=>mode_obj[:freq]}
    self.rule_type = mode_obj[:freq]

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

  def transform_time
    self.duration = self.duration_day.to_i * 86400 + self.duration_hour.to_i * 60 + self.duration_minute.to_i
  end

  def untransform_time
    self.duration ||= 0
    self.duration = self.duration.to_i
    self.duration ||= self.duration.to_i
    self.duration_day ||= self.duration/86400
    self.duration_hour ||= (self.duration%86400)/60
    self.duration_minute ||= self.duration%60
  end

  #生成任务实例的通知方式
  def generate_notify
    if self.notify_program.present?
      Irm::Person.current = Irm::Person.find(self.assigned_to)

      if self.notify_program.notify_type.eql?("EMAIL")
        generate_email_notify
      elsif self.notify_program.notify_type.eql?("INCIDENT")
        generate_incident_notify
      end
    end
  end




  private
    def generate_email_notify
      if self.notify_program.wf_mail_alert_id.present?
        mail_alert = Irm::WfMailAlert.find(self.notify_program.wf_mail_alert_id)
        mail_alert.perform(self)
      end
    end

    def generate_incident_notify
      if self.notify_program.incident_request_hash.present? and self.external_system_id.present?
        incident_hash = eval(self.notify_program.incident_request_hash)
        incident_hash[:requested_by] = self.assigned_to
        incident_hash[:external_system_id] = self.external_system_id
        incident_hash[:title] = self.name
        incident_hash[:summary] = self.description
        watchers = Irm::Person.where(:id => self.member_ids)
        incident_request = Icm::IncidentRequest.new(incident_hash)

        incident_request = prepared_for_create(incident_request)

        #将自定义的必填字段用默认值进行设置
        incident_request.merge_required_default_values

        if incident_request.save!
          watchers.each do |watcher|
            incident_request.add_watcher(watcher, false)
          end
          #事故单创建成功后将id插入到对应的任务中
          self.incident_request_id = incident_request.id
          self.save

          Icm::IncidentHistory.create({:request_id => incident_request.id,
                                       :journal_id => "",
                                       :property_key => "incident_request_id",
                                       :old_value => incident_request.title,
                                       :new_value => ""})
          #如果没有填写support_group, 插入Delay Job任务
          if incident_request.support_group_id.nil? || incident_request.support_group_id.blank?
            Delayed::Job.enqueue(Icm::Jobs::GroupAssignmentJob.new(incident_request.id), [{:bo_code => "ICM_INCIDENT_REQUESTS", :instance_id => incident_request.id}])
          end
        end

      end
    end

    def prepared_for_create(incident_request)
      incident_request.submitted_by = Irm::Person.current.id
      incident_request.submitted_date = Time.now
      incident_request.last_request_date = Time.now
      incident_request.last_response_date = Time.now
      incident_request.next_reply_user_license="SUPPORTER"
      if incident_request.incident_status_id.nil?||incident_request.incident_status_id.blank?
        incident_request.incident_status_id = Icm::IncidentStatus.default_id
      end
      if incident_request.request_type_code.nil?||incident_request.request_type_code.blank?
        incident_request.request_type_code = "REQUESTED_TO_CHANGE"
      end

      if incident_request.report_source_code.nil?||incident_request.report_source_code.blank?
        incident_request.report_source_code = "CUSTOMER_SUBMIT"
      end
      if incident_request.requested_by.present?
        incident_request.contact_id = incident_request.requested_by
      end

      if !incident_request.contact_number.present?&&incident_request.contact_id.present?
        incident_request.contact_number = Irm::Person.find(incident_request.contact_id).bussiness_phone
      end
      incident_request
    end

    def prepare_time_mode
      if self.rule.present?
        return YAML.load(self.rule)
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