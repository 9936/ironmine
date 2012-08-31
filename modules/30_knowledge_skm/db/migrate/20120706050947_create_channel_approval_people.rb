class CreateChannelApprovalPeople < ActiveRecord::Migration
  def up
    create_table :skm_channel_approval_people,:force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false
      t.string   "channel_id", :limit => 22, :null => false
      t.string   "person_id", :limit => 22, :null => false
      t.string   "status_code",    :limit => 30, :default => "ENABLED", :null => false
      t.string   "created_by",     :limit => 22,                        :null => false
      t.string   "updated_by",     :limit => 22,                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :skm_channel_approval_people, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_index :skm_channel_approval_people, ["channel_id", "person_id"], :name => "SKM_CHANNEL_APPROVAL_U1", :unique => true
  end

  def down
    drop_table :skm_channel_approval_people
  end
end
