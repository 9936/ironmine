class CreateGtdTaskAssigns < ActiveRecord::Migration
  def change

    create_table :gtd_task_assigns, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "external_system_id", :limit => 22,:collate => "utf8_bin"
      t.string   "name", :limit => 150
      t.string   "description", :limit => 240
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :gtd_task_assigns, "id", :string, :limit => 22, :collate => "utf8_bin"

    create_table :gtd_task_assign_members, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "task_assign_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "person_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "member_type", :limit => 30, :default => "FROM"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :gtd_task_assign_members, "id", :string, :limit => 22, :collate => "utf8_bin"

    execute("CREATE OR REPLACE VIEW gtd_task_assign_explosions_v AS SELECT a.external_system_id, t.person_id,tl.person_id assign_person_id
             FROM gtd_task_assigns a,gtd_task_assign_members t,gtd_task_assign_members tl
             WHERE a.id = t.task_assign_id and t.task_assign_id = tl.task_assign_id and t.member_type= 'FROM' and tl.member_type= 'TO'")
    
  end
end
