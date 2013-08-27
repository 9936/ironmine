class ChangeSugTables < ActiveRecord::Migration
  def change
    add_column :sug_addresses, :zip_code, :string, :limit => 10, :after => :details
    add_column :sug_categories, :leaf_flag, :string, :default => 'N', :limit => 1, :after => :description

    remove_column :sug_contacts, :zip_code
    remove_column :sug_customers, :zip_code

    drop_table :sug_customer_exp
  end
end
