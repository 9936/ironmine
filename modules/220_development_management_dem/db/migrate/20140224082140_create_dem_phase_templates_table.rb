class CreateDemPhaseTemplatesTable < ActiveRecord::Migration
  def up
    create_table :dem_dev_phase_templates, :force => true do |t|
      t.string   "opu_id", :limit => 22, :null => false, :collate => "utf8_bin"
      t.string   "code", :limit => 30
      t.string   "name", :limit => 100
      t.string   "description", :limit => 250
      t.string   "owner_1_label", :limit => 100
      t.string   "owner_2_label", :limit => 100
      t.string   "owner_3_label", :limit => 100
      t.string   "owner_4_label", :limit => 100
      t.string   "owner_5_label", :limit => 100
      t.string   "owner_6_label", :limit => 100
      t.string   "status_label", :limit => 100
      t.string   "plan_start_label", :limit => 100
      t.string   "plan_end_label", :limit => 100
      t.string   "real_start_label", :limit => 100
      t.string   "real_end_label", :limit => 100

      t.string   "status_code", :limit => 30, :default => "ENABLED"
      t.string   "created_by", :limit => 22, :collate => "utf8_bin"
      t.string   "updated_by", :limit => 22, :collate => "utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :dem_dev_phase_templates, "id", :string, :limit => 22, :collate => "utf8_bin"

    Irm::Sequence.create(:object_name => Dem::DevPhaseTemplate.name,
                         :seq_max => 0,
                         :seq_length => 4,
                         :seq_next => 1)
  end

  def down
  end
end
