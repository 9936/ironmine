class RepairLdapOpuId < ActiveRecord::Migration
  def up
    Irm::ExternalSystemPerson.all.each do |esp|
      person =   Irm::Person.query(esp.person_id).first
      esp.update_attributes(:opu_id=>person.opu_id)  if person.present?
    end
  end

  def down
  end
end
