class CreateMamTables < ActiveRecord::Migration
  def up
    create_table :mam_masters do |t|
      t.string  "opu_id", :limit => 22
      t.string   "master_number",    :limit => 30
      t.string   "master_type",    :limit => 30
      t.string   "system_id",    :limit => 22
      t.string   "submitted_by",    :limit => 22
      t.string   "support_group_id",    :limit => 22
      t.string   "support_person_id",    :limit => 22
      t.string   "master_status_id",  :limit => 22
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

    create_table :mam_systems do |t|
      t.string   "opu_id", :limit => 22
      t.string   "system_name",    :limit => 100
      t.string   "status_code",    :limit => 8
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :mam_systems, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table :mam_system_groups do |t|
      t.string   "opu_id", :limit => 22
      t.string   "system_id",    :limit => 22
      t.string   "group_id",    :limit => 22
      t.string   "status_code",    :limit => 8
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :mam_system_groups, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table :mam_system_people do |t|
      t.string   "opu_id", :limit => 22
      t.string   "system_id",    :limit => 22
      t.string   "person_id",    :limit => 22
      t.string   "status_code",    :limit => 8
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :mam_system_people, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table :mam_master_items do |t|
      t.string   "opu_id", :limit => 22
      t.string   "master_id",    :limit => 22
      t.string   "item_code",    :limit => 30
      t.string   "item_description",    :limit => 240
      t.string   "organization",    :limit => 240
      t.string   "template",    :limit => 30
      t.string   "reference_item",    :limit => 240
      t.string   "primary_unit",    :limit => 25
      t.string   "department",    :limit => 240
      t.string   "business_unit",    :limit => 240
      t.string   "inventory_account",    :limit => 240
      t.string   "inventory_sub_account",    :limit => 240
      t.string   "sn_generation",    :limit => 30
      t.string   "status_code",    :limit => 8
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :mam_master_items, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table :mam_master_scs do |t|
      t.string   "opu_id", :limit => 22
      t.string   "master_id",    :limit => 22
      t.string   "party_name",    :limit => 360
      t.string   "duns_number",    :limit => 240
      t.string   "scs_type",    :limit => 30
      t.string   "country",    :limit => 60
      t.string   "state",    :limit => 60
      t.string   "postal_code",    :limit => 60
      t.string   "city",    :limit => 60
      t.string   "address_line_1",    :limit => 240
      t.string   "address_line_2",    :limit => 240
      t.string   "address_line_3",    :limit => 240
      t.string   "account_type",    :limit => 30
      t.string   "classification",    :limit => 30
      t.string   "credit_limit",    :limit => 100
      t.string   "currency",    :limit => 30
      t.string   "status_code",    :limit => 8
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :mam_master_scs, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table :mam_master_urs do |t|
      t.string   "opu_id", :limit => 22
      t.string   "master_id",    :limit => 8
      t.string   "number",    :limit => 100
      t.string   "responsibility",    :limit => 30
      t.string   "action",    :limit => 30
      t.string   "start_date",    :limit => 30
      t.string   "end_date",    :limit => 30
      t.string   "remark",    :limit => 240
      t.string   "status_code",    :limit => 8
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :mam_master_urs, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table :mam_master_replies do |t|
      t.string   "opu_id", :limit => 22
      t.string   "master_id",    :limit => 22
      t.string   "reply_number",    :limit => 30
      t.string   "reply_type",    :limit => 30
      t.text   "reply_content"
      t.string   "status_code",    :limit => 8
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :mam_master_replies, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end

  def down
  end
end
