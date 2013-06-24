class Emw::MonitorProgram < ActiveRecord::Base
  set_table_name :emw_monitor_programs

  validates_presence_of :name, :assigned_to, :start_at, :end_at

  has_many :monitor_histories, :foreign_key => :monitor_program_id, :dependent => :destroy

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  before_save :init_repeat_type



  scope :select_all, lambda {
    select("#{table_name}.* ").
        with_assigned_person.
        with_mail_alert
  }

  scope :with_assigned_person, lambda {
    joins("JOIN #{Irm::Person.table_name} p ON p.id = #{table_name}.assigned_to").
        select("p.full_name")
  }

  scope :with_mail_alert, lambda {
    joins("JOIN #{Irm::WfMailAlert.table_name} ma ON #{table_name}.mail_alert=ma.id").
        select("ma.name mail_alert_name")
  }

  def execute
    result = {}
    history = Emw::MonitorHistory.new({:monitor_program_id => self.id, :execute_at => Time.zone.now, :execute_by => Irm::Person.current.id})
    history.save
    Emw::MonitorTarget.with_program(self.id).each do |target|
      result[target.id] = target.execute
    end
    result
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

  private
    def init_repeat_type
      self.repeat_type = self.time_mode_obj[:freq]
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
