class UpdateColumnToTables < ActiveRecord::Migration
  def up
    remove_column :cons_connects, :description
    remove_column :cons_cons_types, :description
    remove_column :cons_groups, :description
    remove_column :cons_industries, :description
    remove_column :cons_levels, :description
    remove_column :cons_modules, :description
    remove_column :cons_prices, :description
    remove_column :cons_project_types, :description
    remove_column :cons_statuses, :description

  end

  def down

  end
end
