class Uid::ExternalSystem < ActiveRecord::Base
  set_table_name :uid_external_systems

  has_many :external_systems_tls,:class_name =>"Uid::ExternalSystemsTl",:foreign_key=>"external_system_id"
  attr_accessor :system_name, :system_description
  acts_as_multilingual({:columns =>[:system_name,:system_description],:required=>[:system_name]})  

  has_many :external_system_people, :class_name => "Uid::ExternalSystemPerson",
           :foreign_key => "external_system_code",:primary_key => "external_system_code",:dependent => :destroy

  has_many :people, :class_name => "Irm::Person",
           :finder_sql => "SELECT p.* FROM irm_people p, uid_external_system_people sp, uid_external_systems es " +
                          "WHERE p.id = sp.person_id AND es.external_system_code = sp.external_system_code"

  query_extend

  validates_uniqueness_of :external_system_code
  validates_presence_of :external_system_code

  scope :with_person, lambda{|person_id|
    joins(",#{Uid::ExternalSystemPerson.table_name} esp").
    where("esp.person_id = ?", person_id).
    where("esp.external_system_code = #{table_name}.external_system_code")
  }

  def wrap_system_name
    self[:system_name]
  end

  def owned_people
    Irm::Person.
        with_external_system(self.external_system_code)
  end
end
