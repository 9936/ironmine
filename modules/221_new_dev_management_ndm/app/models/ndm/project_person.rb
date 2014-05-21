class Ndm::ProjectPerson< ActiveRecord::Base
  set_table_name 'ndm_project_people'
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  belongs_to :person, :class_name => "Irm::Person"
  belongs_to :project, :class_name => "Ndm::Project"
end
