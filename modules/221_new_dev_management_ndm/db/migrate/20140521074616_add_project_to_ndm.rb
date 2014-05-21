class AddProjectToNdm < ActiveRecord::Migration
  def change
    create_table :ndm_projects, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "name", :limit => 200
      t.text   "description"
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_column :ndm_projects, "id", :string, :limit => 22, :collate => "utf8_bin"

    create_table :ndm_project_people, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "person_id", :limit => 22
      t.string   "project_id", :limit => 22
      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :ndm_project_people, "id", :string, :limit => 22, :collate => "utf8_bin"
  end
end
