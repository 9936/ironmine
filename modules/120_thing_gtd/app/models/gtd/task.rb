class Gtd::Task < ActiveRecord::Base
  set_table_name :gtd_tasks

  attr_accessor :duration_day, :duration_hour, :duration_minute

  validates_presence_of :name ,:plan_start_at, :plan_end_at, :external_system_id, :assigned_to, :access_type

  before_save :setting_rule
  after_save :create_member_from_str
  before_validation :transform_time

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  attr_accessor :member_str
  has_many :task_members, :foreign_key => :task_id, :dependent => :destroy

  scope :with_all, lambda{select("#{table_name}.*")}


  scope :with_assigned_person, lambda {
    joins("JOIN #{Irm::Person.table_name} p ON p.id = #{table_name}.assigned_to").
        select("p.full_name")
  }


  scope :assigned_to, lambda{|person_id|
    where("#{table_name}.assigned_to = ?", person_id)
  }

  def setting_rule
    if self.repeat and self.repeat.eql?("Y")
      self.rule_type = self.time_mode_obj[:freq]
    else
      self.rule = nil
      self.rule_type = nil
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




  private
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