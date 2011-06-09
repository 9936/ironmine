class CreateTableIcmGroupAssignmentsDetail < ActiveRecord::Migration
  def self.up
    create_table "icm_group_assignment_details", :force => true do |t|
      t.string   "group_assignment_id",       :limit => 30,  :null => false
      t.string   "source_type",     :limit => 30,  :null => false
      t.integer   "source_id"
      t.string   "status_code",       :limit => 30,  :null => false
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    drop_table :icm_group_assignment_details
  end
end
