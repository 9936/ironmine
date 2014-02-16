class RefillPersonIdForElapse < ActiveRecord::Migration
  def up
    Irm::Person.current = Irm::Person.where(:login_name=>"ironmine").first
    Icm::IncidentJournalElapse.rebuild
  end

  def down
  end
end
