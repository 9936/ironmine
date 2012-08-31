class CreateChangeImplementTable < ActiveRecord::Migration
  def up
    create_table "chm_change_task_phases", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "code",          :limit => 60, :null => false
      t.integer  "display_sequence" ,:default=>10
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :chm_change_task_phases, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_task_phases", ["code"], :name => "CHM_CHANGE_TASK_PHASES_N1"

    create_table "chm_change_task_phases_tl", :force => true do |t|
      t.string   "opu_id",           :limit => 22 , :collate=>"utf8_bin"
      t.string   "change_task_phase_id",:limit => 22, :collate=>"utf8_bin"
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

    change_column :chm_change_task_phases_tl, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_task_phases_tl", ["change_task_phase_id", "language"], :name => "CHM_CHANGE_TASK_PHASES_TL_U1", :unique => true
    add_index "chm_change_task_phases_tl", ["change_task_phase_id"], :name => "CHM_CHANGE_TASK_PHASES_TL_N1"

    execute('CREATE OR REPLACE VIEW chm_change_task_phases_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM chm_change_task_phases t,chm_change_task_phases_tl tl
                         WHERE t.id = tl.change_task_phase_id')


    create_table "chm_change_task_templates", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "code",          :limit => 60, :null => false
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :chm_change_task_templates, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_task_templates", ["code"], :name => "CHM_CHANGE_TASK_TEMPLATES_N1"

    create_table "chm_change_task_templates_tl", :force => true do |t|
      t.string   "opu_id",           :limit => 22 , :collate=>"utf8_bin"
      t.string   "change_task_template_id",:limit => 22, :collate=>"utf8_bin"
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

    change_column :chm_change_task_templates_tl, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_task_templates_tl", ["change_task_template_id", "language"], :name => "CHM_CHANGE_TASK_TEMPLATES_TL_U1", :unique => true
    add_index "chm_change_task_templates_tl", ["change_task_template_id"], :name => "CHM_CHANGE_TASK_TEMPLATES_TL_N1"

    execute('CREATE OR REPLACE VIEW chm_change_task_templates_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM chm_change_task_templates t,chm_change_task_templates_tl tl
                         WHERE t.id = tl.change_task_template_id')

    create_table "chm_change_tasks", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "source_type",   :limit => 60, :null => false
      t.string   "source_id",     :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "change_task_phase_id",:limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "support_group_id",        :limit => 22, :collate=>"utf8_bin"
      t.string   "support_person_id",       :limit => 22, :collate=>"utf8_bin"
      t.datetime "plan_start_date"
      t.datetime "plan_end_date"
      t.datetime "start_date"
      t.datetime "end_date"
      t.string   "name",          :limit => 150, :null => false
      t.text     "message"
      t.text     "description"
      t.string   "status",        :limit => 30, :null => false
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :chm_change_tasks, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_tasks", ["source_type","source_id"], :name => "CHM_CHANGE_TASKS_N1"

    create_table "chm_change_task_depends", :force => true do |t|
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "change_task_id",   :limit => 60, :null => false
      t.string   "depend_task_id",     :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :chm_change_task_depends, "id", :string,:limit=>22, :collate=>"utf8_bin"

    add_index "chm_change_task_depends", ["change_task_id", "depend_task_id"], :name => "CHM_CHANGE_TASK_DEPENDS_U1", :unique => true

  end

  def down
    drop_table :chm_change_task_phases
    drop_table :chm_change_task_phases_tl
    execute('DROP VIEW chm_change_task_phases_vl')
    drop_table :chm_change_task_templates
    drop_table :chm_change_task_templates_tl
    execute('DROP VIEW chm_change_task_templates_vl')
    drop_table :chm_change_tasks
    drop_table :chm_change_task_depends
  end
end
