class AddColumnToTables < ActiveRecord::Migration
  def change
    add_column :cons_connects, :description, :string
    add_column :cons_cons_types, :description, :string
    add_column :cons_groups, :description, :string
    add_column :cons_industries, :description, :string
    add_column :cons_levels, :description, :string
    add_column :cons_modules, :description, :string
    add_column :cons_prices, :description, :string
    add_column :cons_project_types, :description, :string
    add_column :cons_statuses, :description, :string
  end
end
