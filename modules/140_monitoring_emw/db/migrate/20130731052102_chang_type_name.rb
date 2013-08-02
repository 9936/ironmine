class ChangTypeName < ActiveRecord::Migration
  def change
    rename_column :emw_components, :type, :component_type
  end
end
