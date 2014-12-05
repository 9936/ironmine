class CreateNdmTables < ActiveRecord::Migration
  def up
    create_table :ndm_dev_managements, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "project", :limit => 30
      t.string   "no", :limit => 100
      t.string   "name", :limit => 200
      t.string  "module", :limit => 30
      t.text   "description"
      t.string   "priority", :limit => 30
      t.string   "dev_type", :limit => 30
      t.string   "dev_difficulty", :limit => 30
      t.string   "method", :limit => 30

      #General Design
      t.string   "gd_owner", :limit => 100
      t.string   "gd_status", :limit => 30
      t.date   "gd_plan_start"
      t.date   "gd_plan_end"
      #Functional Design
      t.string   "fd_owner", :limit => 100
      t.string   "fd_status", :limit => 30
      t.date   "fd_plan_start"
      t.date   "fd_plan_end"
      #Functional Design Review
      t.string   "fdr_owner", :limit => 100
      t.string   "fdr_status", :limit => 30
      t.date   "fdr_plan_end"
      #Technical Design
      t.string   "td_owner", :limit => 100
      t.string   "td_status", :limit => 30
      t.date   "td_plan_end"
      #Coding
      t.string   "co_owner", :limit => 100
      t.string   "co_status", :limit => 30
      t.date   "co_plan_end"
      #Testing
      t.string   "te_owner", :limit => 100
      t.string   "te_status", :limit => 30
      t.date   "te_plan_end"
      #Setups&Installation
      t.string   "si_owner", :limit => 100
      t.string   "si_status", :limit => 30
      t.date   "si_plan_end"
      #Acceptance Testing
      t.string   "at_owner", :limit => 100
      t.string   "at_status", :limit => 30
      t.date   "at_plan_end"
      #Golive
      t.string   "go_owner", :limit => 100
      t.string   "go_status", :limit => 30
      t.date   "go_plan_end"

      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
  end
end
