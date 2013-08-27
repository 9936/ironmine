class CreateSkills < ActiveRecord::Migration
  def change
    create_table :sug_skills, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "name", :limit => 150
      t.string   "description", :limit => 240
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :sug_skills, "id", :string, :limit => 22, :collate => "utf8_bin"

    create_table :sug_person_skills, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "person_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "skill_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :sug_person_skills, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index :sug_person_skills, [:person_id, :skill_id], :name => "SUG_PERSON_SKILLS_N1"

    create_table :sug_category_skills, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "category_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "skill_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :sug_category_skills, "id", :string, :limit => 22, :collate => "utf8_bin"
    add_index :sug_category_skills, [:category_id, :skill_id], :name => "SUG_CATEGORY_SKILLS_N1"
  end
end
