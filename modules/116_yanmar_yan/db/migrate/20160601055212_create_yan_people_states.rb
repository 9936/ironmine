class CreateYanPeopleStates < ActiveRecord::Migration
  def change
    create_table :yan_people_states do |t|
      t.string          "person_id",  :limit => 22
      t.string          "state",      :limit => 22
      t.datetime        "last_operate_time"

      t.timestamps
    end
  end
end
