class CreateEntryApprovalPeople < ActiveRecord::Migration
  def up
    create_table :skm_entry_approval_people,:force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false
      t.string   "entry_header_id", :limit => 22, :null => false
      t.string   "person_id", :limit => 22, :null => false
      t.string   "approval_flag",  :limit => 1,   :default => "N"
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",     :limit => 22,                        :null => false
      t.string   "updated_by",     :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :skm_entry_approval_people, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index :skm_entry_approval_people, ["entry_header_id", "person_id"], :name => "SKM_ENTRY_APPROVAL_U1", :unique => true
  end

  def down
    drop_table :skm_entry_approval_people
  end
end

