class CreateMamTables < ActiveRecord::Migration
  def up
    create_table :mam_masters do |t|
      t.string   "master_number",    :limit => 8
      t.string   "master_type",    :limit => 8
      t.string   "system_id",    :limit => 8
      t.string   "submitted_by",    :limit => 8
      t.string   "support_group_id",    :limit => 8
      t.string   "support_person_id",    :limit => 8
      t.string   "urs_user_name",    :limit => 8
      t.string   "urs_start_date",    :limit => 8
      t.string   "urs_end_date",    :limit => 8
      t.string   "urs_person",    :limit => 8
      t.string   "urs_description",    :limit => 8
      t.string   "urs_status",    :limit => 8
      t.string   "urs_email",    :limit => 8
      t.string   "status_code",    :limit => 8
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :mam_masters, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table :mam_systems do |t|
      t.string   "system_id",    :limit => 8
      t.string   "system_name",    :limit => 8
      t.string   "status_code",    :limit => 8
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :mam_systems, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table :mam_system_groups do |t|
      t.string   "system_id",    :limit => 8
      t.string   "group_id",    :limit => 8
      t.string   "status_code",    :limit => 8
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :mam_system_groups, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table :mam_master_items do |t|
      t.string   "master_id",    :limit => 8
      t.string   "item_code",    :limit => 8
      t.string   "item_description",    :limit => 8
      t.string   "organization",    :limit => 8
      t.string   "template",    :limit => 8
      t.string   "reference_item",    :limit => 8
      t.string   "primary_unit",    :limit => 8
      t.string   "department",    :limit => 8
      t.string   "business_unit",    :limit => 8
      t.string   "inventory_account",    :limit => 8
      t.string   "inventory_sub_account",    :limit => 8
      t.string   "sn_generation",    :limit => 8
      t.string   "status_code",    :limit => 8
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :mam_master_items, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table :mam_master_scs do |t|
      t.string   "master_id",    :limit => 8
      t.string   "party_name",    :limit => 8
      t.string   "duns_number",    :limit => 8
      t.string   "scs_type",    :limit => 8
      t.string   "country",    :limit => 8
      t.string   "state",    :limit => 8
      t.string   "postal_code",    :limit => 8
      t.string   "city",    :limit => 8
      t.string   "address_line_1",    :limit => 8
      t.string   "address_line_2",    :limit => 8
      t.string   "address_line_3",    :limit => 8
      t.string   "account_type",    :limit => 8
      t.string   "classification",    :limit => 8
      t.string   "credit_limit",    :limit => 8
      t.string   "currency",    :limit => 8
      t.string   "status_code",    :limit => 8
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :mam_master_scs, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table :mam_master_urs do |t|
      t.string   "master_id",    :limit => 8
      t.string   "number",    :limit => 8
      t.string   "responsibility",    :limit => 8
      t.string   "action",    :limit => 8
      t.string   "start_date",    :limit => 8
      t.string   "end_date",    :limit => 8
      t.string   "remark",    :limit => 8
      t.string   "status_code",    :limit => 8
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :mam_master_urs, "id", :string,:limit=>22, :collate=>"utf8_bin"

    create_table :mam_master_replies do |t|
      t.string   "master_id",    :limit => 8
      t.string   "reply_number",    :limit => 8
      t.string   "reply_type",    :limit => 8
      t.string   "reply_content",    :limit => 8
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
