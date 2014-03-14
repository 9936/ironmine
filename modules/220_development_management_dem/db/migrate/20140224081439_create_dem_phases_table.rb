class CreateDemPhasesTable < ActiveRecord::Migration
  def up
    create_table :dem_dev_phases, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "dev_management_id", :limit => 22
      t.string   "dev_phase_template_id", :limit => 22
      t.string   "owner_1", :limit => 100
      t.string   "owner_2", :limit => 100
      t.string   "owner_3", :limit => 100
      t.string   "owner_4", :limit => 100
      t.string   "owner_5", :limit => 100
      t.string   "owner_6", :limit => 100
      t.string   "status", :limit => 100
      t.integer  "display_sequence"
      t.date   "plan_start"
      t.date   "plan_end"
      t.date   "real_start"
      t.date   "real_end"

      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :dem_dev_phases, "id", :string, :limit => 22, :collate => "utf8_bin"

  end

  def down
  end
end
