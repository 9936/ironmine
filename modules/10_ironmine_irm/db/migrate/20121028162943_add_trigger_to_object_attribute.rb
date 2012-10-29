class AddTriggerToObjectAttribute < ActiveRecord::Migration
  def change
    add_column :irm_object_attributes, :trigger_flag,:string, :limit=>1, :default => "N", :after => "filter_flag"
  end
end
