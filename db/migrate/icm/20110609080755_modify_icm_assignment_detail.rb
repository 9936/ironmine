class ModifyIcmAssignmentDetail < ActiveRecord::Migration
  def self.up
    drop_table :icm_group_assignments
    drop_table :icm_group_assignment_details

    create_table "icm_group_assignments", :force => true do |t|
      t.string   "support_group_id",       :limit => 30,  :null => false
      t.string   "source_type",     :limit => 30,  :null => false
      t.integer  "source_id"
      t.string   "status_code",       :limit => 30,  :null => false
      t.integer  "created_by"
      t.integer  "updated_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    drop_table :icm_group_assignments
    drop_table :icm_group_assignment_details

    create_table "icm_group_assignments", :force => true do |t|
      t.integer :company_id
      t.integer :organization_id
      t.string :support_group_code, :limit => 30
      t.string :event_type, :limit => 30
      t.string :status_code, :limit => 30, :null => false
      t.integer :created_by
      t.integer :updated_by
      t.datetime :created_at
      t.datetime :updated_at
    end

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
end
