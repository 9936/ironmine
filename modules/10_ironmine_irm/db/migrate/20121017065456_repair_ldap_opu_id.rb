class RepairLdapOpuId < ActiveRecord::Migration
  def up
    Irm::ExternalSystemPerson.all.each do |esp|
      esp.update_attributes(:opu_id=>Irm::Person.find(esp.person_id).opu_id)
    end
  end

  def down
  end
end
