class AddCurrentStatusToDemPhaseTemplate < ActiveRecord::Migration
  def change
    add_column :dem_dev_phase_templates, :current_status, :string, :limit => 50, :after => :real_end_label
  end
end
