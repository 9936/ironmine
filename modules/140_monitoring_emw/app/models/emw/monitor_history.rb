class Emw::MonitorHistory < ActiveRecord::Base
  set_table_name :emw_monitor_histories

  belongs_to :monitor_program, :foreign_key => :monitor_program_id
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  def self.select_all
    select("#{table_name}.*").
        with_execute_person
  end

  scope :with_program, lambda {|program_id|
    where("#{table_name}.monitor_program_id=?", program_id).
        order("#{table_name}.execute_at desc")
  }

  scope :with_execute_person, lambda {
    joins("JOIN #{Irm::Person.table_name} p ON p.id = #{table_name}.execute_by").
        select("p.full_name")
  }

end
