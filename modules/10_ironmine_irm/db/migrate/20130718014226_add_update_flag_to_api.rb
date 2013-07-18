class AddUpdateFlagToApi < ActiveRecord::Migration
  def change
    add_column :irm_rest_apis, :update_flag, :string, :limit => 1, :default => 'N', :after => :name
  end
end
