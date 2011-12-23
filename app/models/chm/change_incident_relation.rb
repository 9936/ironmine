class Chm::ChangeIncidentRelation < ActiveRecord::Base
  set_table_name :chm_change_incident_relations

  belongs_to :change_request
  belongs_to :incident_request,:class_name => "Icm::IncidentRequest"

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  validates_uniqueness_of :change_request_id,:scope => [:incident_request_id]
end
