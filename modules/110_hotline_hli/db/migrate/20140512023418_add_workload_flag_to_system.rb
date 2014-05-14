class AddWorkloadFlagToSystem < ActiveRecord::Migration
  def change
    add_column :irm_external_systems, :strict_workload,  :string, :limit => 1, :after => :opu_id, :default => 'N'
  end
end
