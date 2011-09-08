class Icm::StatusTransform < ActiveRecord::Base
  set_table_name :icm_status_transforms
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu

  scope :with_from_status,lambda{
    joins("JOIN #{Icm::IncidentStatus.view_name} from_status ON from_status.id = #{table_name}.from_status_id").
    select("from_status.incident_status_code from_status_code")
  }

  scope :with_to_status,lambda{
    joins("JOIN #{Icm::IncidentStatus.view_name} to_status ON from_status.id = #{table_name}.from_status_id").
    select("to_status.incident_status_code to_status_code")
  }

  scope :target,lambda{|from_status_id,event|
    where("#{table_name}.from_status_id = ? AND #{table_name}.event_code = ?",from_status_id,event)
  }

end
