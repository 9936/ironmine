class AddDescriptionToTables < ActiveRecord::Migration
  def change
    add_column :cons_connects, :description, :text
    add_column :cons_cons_types, :description, :text
    add_column :cons_groups, :description, :text
    add_column :cons_industries, :description, :text
    add_column :cons_levels, :description, :text
    add_column :cons_modules, :description, :text
    add_column :cons_prices, :description, :text
    add_column :cons_project_types, :description, :text
    add_column :cons_statuses, :description, :text
  end
end
