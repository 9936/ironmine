class Uid::ExternalSystemPerson < ActiveRecord::Base
  set_table_name :uid_external_system_people
  query_extend

  attr_accessor :temp_id_string

  validates_uniqueness_of :person_id, :scope => :external_system_code

#  belongs_to :person, :class_name => "Irm::Person",
#             :foreign_key => "person_id", :primary_key => "id"
#
#  belongs_to :external_system, :class_name => "Uid::ExternalSystem",
#             :foreign_key => "external_system_code", :primary_key => "external_system_code"

end