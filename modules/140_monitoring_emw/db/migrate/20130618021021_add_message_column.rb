class AddMessageColumn < ActiveRecord::Migration
  def change
    add_column :emw_interface_columns, :message_flag, :string, :limit => 1, :default => "N", :after => "error_flag"
  end
end
