class UpdateColumnToProduct < ActiveRecord::Migration
  def up
    remove_column :cons_products, :pro_respond_time
    remove_column :cons_products, :pro_handle_time
    remove_column :cons_products, :pro_update_time
    remove_column :cons_products, :pro_total_time
    remove_column :cons_products, :pro_max_time

    remove_column :cons_products, :pro_remind_rate
    remove_column :cons_products, :pro_warning_rate

    add_column :cons_products, :pro_respond_time, :float
    add_column :cons_products, :pro_handle_time, :float
    add_column :cons_products, :pro_update_time, :float
    add_column :cons_products, :pro_total_time, :float
    add_column :cons_products, :pro_max_time, :float

    add_column :cons_products, :pro_remind_rate, :integer
    add_column :cons_products, :pro_warning_rate, :integer
  end

  def down
  end
end
