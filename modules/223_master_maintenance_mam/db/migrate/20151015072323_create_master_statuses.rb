class CreateMasterStatuses < ActiveRecord::Migration
  def up
    create_table :mam_master_statuses do |t|
      t.string   "opu_id", :limit => 22
      t.string   "master_number",    :limit => 30
      t.string   "master_type",    :limit => 30
      t.string   "category", :limit => 30
      t.string   "system_id",    :limit => 22
      t.string   "submitted_by",    :limit => 22
      t.string   "support_group_id",    :limit => 22
      t.string   "support_person_id",    :limit => 22
      t.string   "master_status_id",  :limit => 22
      t.text     "remark"
      t.string   "contact",  :limit => 100
      t.string   "contact_number",  :limit => 100
      t.string   "urs_user_name",    :limit => 100
      t.string   "urs_start_date",    :limit => 20
      t.string   "urs_end_date",    :limit => 20
      t.string   "urs_person",    :limit => 240
      t.string   "urs_description",    :limit => 240
      t.string   "urs_status",    :limit => 30
      t.string   "urs_email",    :limit => 240
      t.string   "status_code",    :limit => 8
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :mam_masters, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end

  def down
  end

  # def change
  #   create_table :master_statuses do |t|
  #
  #     t.timestamps
  #   end
  # end
end
