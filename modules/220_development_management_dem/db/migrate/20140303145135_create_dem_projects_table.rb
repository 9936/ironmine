class CreateDemProjectsTable < ActiveRecord::Migration
  def up
    create_table :dem_projects, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "code", :limit => 30
      t.string   "name", :limit => 22
      t.text   "description"

      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :dem_projects, "id", :string, :limit => 22, :collate => "utf8_bin"

    rename_column :dem_dev_managements, :project, :project_id
    change_column :dem_dev_managements, :project_id, :string, :limit => 22, :collate => "utf8_bin"
    rename_column :dem_dev_managements, :related_project, :related_project_id
    change_column :dem_dev_managements, :related_project_id, :string, :limit => 22, :collate => "utf8_bin"

    Irm::Sequence.create(:object_name => Dem::Project.name,
                         :seq_max => 0,
                         :seq_length => 4,
                         :seq_next => 0)
  end

  def down
  end
end
