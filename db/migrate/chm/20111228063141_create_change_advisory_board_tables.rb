class CreateChangeAdvisoryBoardTables < ActiveRecord::Migration
  def up
    create_table "chm_advisory_boards", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "code",          :limit => 60, :null => false
      t.string   "name",          :limit => 150, :null => false
      t.string   "description",   :limit => 240
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :chm_advisory_boards, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_advisory_boards", ["code","opu_id"], :name => "CHM_ADVISORY_BOARDS_U1"

    create_table "chm_advisory_board_members", :force => true do |t|
      t.string   "opu_id",              :limit => 22 , :collate=>"utf8_bin"
      t.string   "advisory_board_id",   :limit => 22, :collate=>"utf8_bin"
      t.string   "person_id",           :limit => 30,  :null => false
      t.string   "status_code",         :limit => 30, :null => false
      t.string   "created_by",          :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",          :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :chm_advisory_board_members, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_advisory_board_members", ["advisory_board_id", "person_id"], :name => "CHM_ADVISORY_BOARD_MEMBERS_U1", :unique => true

    create_table "chm_change_approvals", :force => true do |t|
      t.string   "opu_id",              :limit => 22 , :collate=>"utf8_bin"
      t.string   "change_request_id",   :limit => 22, :collate=>"utf8_bin"
      t.string   "person_id",           :limit => 22, :collate=>"utf8_bin"
      t.datetime "send_at"
      t.string   "approve_status",      :limit => 30, :null => false
      t.string   "comment",             :limit => 240
      t.datetime "approve_at"
      t.string   "status_code",         :limit => 30, :null => false
      t.string   "created_by",          :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",          :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :chm_change_approvals, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_approvals", ["change_request_id", "person_id"], :name => "CHM_CHANGE_APPROVALS_U1", :unique => true



  end

  def down
    drop_table  :chm_advisory_boards
    drop_table  :chm_advisory_board_members
    drop_table  :chm_change_approvals
  end
end
