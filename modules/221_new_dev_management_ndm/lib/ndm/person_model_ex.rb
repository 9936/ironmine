module Ndm::PersonModelEx
  def self.included(base)
    base.class_eval do
      has_many :project_people, :class_name => "Ndm::ProjectPerson", :foreign_key => "person_id", :primary_key => "id", :dependent => :destroy
      has_many :projects, :class_name => "Ndm::Project", :through => :project_people
    end
  end
end