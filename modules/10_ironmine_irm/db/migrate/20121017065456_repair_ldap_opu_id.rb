class RepairLdapOpuId < ActiveRecord::Migration
  def up
    Irm::ExternalSystemPerson.each do |esp|
      esp.update_attributes(:opu_id=>Irm::Person.find(esp.person_id).opu_id)
    end
    Irm::ExternalSystemPerson.each do |esp|
      esp.update_attributes(:opu_id=>Irm::Person.find(esp.person_id).opu_id)
    end
  end

  def down
  end
end
