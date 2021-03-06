class Emw::MonitorProgram < ActiveRecord::Base
  set_table_name :emw_monitor_programs

  validates_presence_of :name, :assigned_to

  has_many :monitor_histories, :foreign_key => :monitor_program_id, :dependent => :destroy

  acts_as_timetrigger

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}




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

  def perform
    puts "===========start execute program=============="
    if self.mail_alert.present?
      mail_alert = Irm::WfMailAlert.find(self.mail_alert)
      mail_alert.perform(self)
    end
    puts "===========end execute program=============="
  end

  def execute(target_id=nil)
    result = {}
    if self.history_flag.eql?('Y')
      history = Emw::MonitorHistory.new({:monitor_program_id => self.id,
                                         :execute_at => Time.zone.now,
                                         :execute_by => Irm::Person.current.id})
      history.save
    end

    if target_id.present?
      targets = Emw::MonitorTarget.with_program(self.id).query_by_id(target_id)
    else
      targets = Emw::MonitorTarget.with_program(self.id)
    end

    targets.each do |target|
      if target.target_type.eql?("INTERFACE")
        origin_target = Emw::Interface.find(target.target_id)
      elsif  target.target_type.eql?("DATABASE")
        origin_target = Emw::Database.find(target.target_id)
      end
      result_arr = target.execute
      #将执行结果根据类型进行分类
      result[target.target_type.downcase.to_sym] = []

      result_arr.each do |i|
        i[:name] = origin_target[:name]
        i[:description] = origin_target[:description]
        i[:target_type] = target.target_type
      end

      result[target.target_type.downcase.to_sym] += result_arr
    end
    result
  end

end
