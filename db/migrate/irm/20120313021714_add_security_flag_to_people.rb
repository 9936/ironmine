class AddSecurityFlagToPeople < ActiveRecord::Migration
  def change
    add_column :irm_people, "security_flag", :string, :limit=>24,:after => :login_name
    Irm::Person.all.each do |person|
      person.update_attributes(:security_flag => ActiveSupport::SecureRandom.hex(12))
    end
  end
end
