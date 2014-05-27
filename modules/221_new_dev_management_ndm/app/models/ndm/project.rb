class Ndm::Project < ActiveRecord::Base
  set_table_name 'ndm_projects'
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  has_many :project_people, :class_name => "Ndm::ProjectPerson", :foreign_key => "person_id", :primary_key => "id", :dependent => :destroy
  has_many :people, :class_name => "Irm::Person", :through => :project_people

  scope :with_member, lambda{|current_person_id|
    joins(",#{Ndm::ProjectPerson.table_name} npp2").where("npp2.person_id = ?", current_person_id).where("npp2.project_id = #{table_name}.id")
  }
end
