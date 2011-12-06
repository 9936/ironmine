class CreateChmStatusPriorityUrgencyImpact < ActiveRecord::Migration
  def up
    create_table "chm_change_statuses", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "code",          :limit => 60, :null => false
      t.integer  "display_sequence" ,:default=>10
      t.string   "default_flag",  :limit => 1, :null => false,:default=>"N"
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :chm_change_statuses, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_statuses", ["code"], :name => "CHM_CHANGE_STATUSES_N1"

    create_table "chm_change_statuses_tl", :force => true do |t|
      t.string   "opu_id",           :limit => 22 , :collate=>"utf8_bin"
      t.string   "change_status_id",        :limit => 22, :collate=>"utf8_bin"
      t.string   "language",         :limit => 30,  :null => false
      t.string   "name",             :limit => 150
      t.string   "description",      :limit => 240
      t.string   "source_lang",      :limit => 30,  :null => false
      t.string   "status_code",      :limit => 30, :null => false
      t.string   "created_by",       :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",       :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :chm_change_statuses_tl, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_statuses_tl", ["change_status_id", "language"], :name => "CHM_CHANGE_STATUSES_TL_U1", :unique => true
    add_index "chm_change_statuses_tl", ["change_status_id"], :name => "CHM_CHANGE_STATUSES_TL_N1"

    execute('CREATE OR REPLACE VIEW chm_change_statuses_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM chm_change_statuses t,chm_change_statuses_tl tl
                         WHERE t.id = tl.change_status_id')

    create_table "chm_change_urgencies", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "code",          :limit => 60, :null => false
      t.integer  "weight_values"
      t.integer  "display_sequence" ,:default=>10
      t.string   "default_flag",  :limit => 1, :null => false,:default=>"N"
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :chm_change_urgencies, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_urgencies", ["code"], :name => "CHM_CHANGE_URGENCIES_N1"

    create_table "chm_change_urgencies_tl", :force => true do |t|
      t.string   "opu_id",           :limit => 22 , :collate=>"utf8_bin"
      t.string   "change_urgency_id",        :limit => 22, :collate=>"utf8_bin"
      t.string   "language",         :limit => 30,  :null => false
      t.string   "name",             :limit => 150
      t.string   "description",      :limit => 240
      t.string   "source_lang",      :limit => 30,  :null => false
      t.string   "status_code",      :limit => 30, :null => false
      t.string   "created_by",       :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",       :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :chm_change_urgencies_tl, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_urgencies_tl", ["change_urgency_id", "language"], :name => "CHM_CHANGE_URGENCIES_TL_U1", :unique => true
    add_index "chm_change_urgencies_tl", ["change_urgency_id"], :name => "CHM_CHANGE_URGENCIES_TL_N1"

    execute('CREATE OR REPLACE VIEW chm_change_urgencies_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM chm_change_urgencies t,chm_change_urgencies_tl tl
                         WHERE t.id = tl.change_urgency_id')


    create_table "chm_change_impacts", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "code",          :limit => 60, :null => false
      t.integer  "weight_values"
      t.integer  "display_sequence" ,:default=>10
      t.string   "default_flag",  :limit => 1, :null => false,:default=>"N"
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :chm_change_impacts, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_impacts", ["code"], :name => "CHM_CHANGE_IMPACTS_N1"

    create_table "chm_change_impacts_tl", :force => true do |t|
      t.string   "opu_id",           :limit => 22 , :collate=>"utf8_bin"
      t.string   "change_impact_id",        :limit => 22, :collate=>"utf8_bin"
      t.string   "language",         :limit => 30,  :null => false
      t.string   "name",             :limit => 150
      t.string   "description",      :limit => 240
      t.string   "source_lang",      :limit => 30,  :null => false
      t.string   "status_code",      :limit => 30, :null => false
      t.string   "created_by",       :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",       :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :chm_change_impacts_tl, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_impacts_tl", ["change_impact_id", "language"], :name => "CHM_CHANGE_IMPACTS_TL_U1", :unique => true
    add_index "chm_change_impacts_tl", ["change_impact_id"], :name => "CHM_CHANGE_IMPACTS_TL_N1"

    execute('CREATE OR REPLACE VIEW chm_change_impacts_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM chm_change_impacts t,chm_change_impacts_tl tl
                         WHERE t.id = tl.change_impact_id')


    create_table "chm_change_priorities", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "code",          :limit => 60, :null => false
      t.integer  "weight_values"
      t.integer  "display_sequence" ,:default=>10
      t.string   "default_flag",  :limit => 1, :null => false,:default=>"N"
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :chm_change_priorities, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_priorities", ["code"], :name => "CHM_CHANGE_PRIORITIES_N1"

    create_table "chm_change_priorities_tl", :force => true do |t|
      t.string   "opu_id",           :limit => 22 , :collate=>"utf8_bin"
      t.string   "change_priority_id",        :limit => 22, :collate=>"utf8_bin"
      t.string   "language",         :limit => 30,  :null => false
      t.string   "name",             :limit => 150
      t.string   "description",      :limit => 240
      t.string   "source_lang",      :limit => 30,  :null => false
      t.string   "status_code",      :limit => 30, :null => false
      t.string   "created_by",       :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",       :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :chm_change_priorities_tl, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_priorities_tl", ["change_priority_id", "language"], :name => "CHM_CHANGE_PRIORITIES_TL_U1", :unique => true
    add_index "chm_change_priorities_tl", ["change_priority_id"], :name => "CHM_CHANGE_PRIORITIES_TL_N1"

    execute('CREATE OR REPLACE VIEW chm_change_priorities_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM chm_change_priorities t,chm_change_priorities_tl tl
                         WHERE t.id = tl.change_priority_id')

  end

  def down
    drop_table :chm_change_statuses
    drop_table :chm_change_statuses_tl
    execute('DROP VIEW chm_change_statuses_vl')
    drop_table :chm_change_urgencies
    drop_table :chm_change_urgencies_tl
    execute('DROP VIEW chm_change_urgencies_vl')
    drop_table :chm_change_impacts
    drop_table :chm_change_impacts_tl
    execute('DROP VIEW chm_change_impacts_vl')
    drop_table :chm_change_priorities
    drop_table :chm_change_priorities_tl
    execute('DROP VIEW chm_change_priorities_vl' )
  end
end
