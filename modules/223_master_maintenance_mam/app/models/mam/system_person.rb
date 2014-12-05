include ActionView::Helpers::SanitizeHelper

class Mam::SystemPerson < ActiveRecord::Base
  set_table_name :mam_system_people
  query_extend

  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_person, lambda{
    joins(",#{Irm::Person.table_name} ip").
        where("ip.id = #{table_name}.person_id").
        select("ip.full_name person_name, ip.email_address email_address")
  }
end
