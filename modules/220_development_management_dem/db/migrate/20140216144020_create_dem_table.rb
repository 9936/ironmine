class CreateDemTable < ActiveRecord::Migration
  def up
    create_table :dem_dev_managements, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "project", :limit => 30
      t.string   "gap_no", :limit => 100
      t.string   "related_project", :limit => 30
      t.string   "related_project_gap_no", :limit => 100
      t.string   "name", :limit => 200
      t.text   "description"
      t.text   "investigation_result"
      t.string   "company", :limit => 30
      t.string   "category", :limit => 30
      t.string   "system", :limit => 30
      t.string   "priority2", :limit => 30
      t.string   "designated_module", :limit => 30
      t.string   "owner", :limit => 30
      t.string   "classification", :limit => 30
      t.string   "dev_type", :limit => 30
      t.string   "dev_difficulty", :limit => 30
      t.string   "gt_local", :limit => 30
      t.string   "dev_status", :limit => 30
      t.string   "completed_phase", :limit => 30
      t.string   "addon_priority", :limit => 30
      t.string   "fun_des_owner", :limit => 100
      t.string   "fun_des_status", :limit => 30
      t.date   "fun_des_plan_start"
      t.date   "fun_des_plan_end"
      t.date   "fun_des_real_start"
      t.date   "fun_des_real_end"
      t.string   "tec_dev_owner", :limit => 100
      t.string   "tec_dev_status", :limit => 30
      t.date   "tec_dev_plan_start"
      t.date   "tec_dev_plan_end"
      t.date   "tec_dev_real_start"
      t.date   "tec_dev_real_end"
      t.string   "fun_tes_owner", :limit => 100
      t.string   "fun_tes_owner2", :limit => 100
      t.string   "fun_tes_owner3", :limit => 100
      t.string   "fun_tes_status", :limit => 30
      t.date   "fun_tes_plan_start"
      t.date   "fun_tes_plan_end"
      t.date   "fun_tes_real_start"
      t.date   "fun_tes_real_end"
      t.string   "review_owner", :limit => 100
      t.string   "review_owner2", :limit => 100
      t.string   "review_owner3", :limit => 100
      t.string   "review_owner4", :limit => 100
      t.string   "review_status", :limit => 100
      t.date   "review_plan_start"
      t.date   "review_plan_end"
      t.date   "review_real_start"
      t.date   "review_real_end"

      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :dem_dev_managements, "id", :string, :limit => 22, :collate => "utf8_bin"

  end

  def down
  end
end
