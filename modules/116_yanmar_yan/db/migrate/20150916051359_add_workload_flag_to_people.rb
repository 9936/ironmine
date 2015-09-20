class AddWorkloadFlagToPeople < ActiveRecord::Migration
  def change
    add_column :irm_people, :workload_flag,  :string, :limit => 1, :after => :opu_id, :default => 'N'
  end
end
