class RemovePasswordFromCustomer < ActiveRecord::Migration
  def up
    remove_column :cons_customers, :customer_password
  end

  def down
  end
end
