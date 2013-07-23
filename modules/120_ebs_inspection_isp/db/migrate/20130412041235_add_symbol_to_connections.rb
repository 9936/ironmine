class AddSymbolToConnections < ActiveRecord::Migration
  def change
    add_column :isp_connections, :object_symbol, :string, :after => :password
  end
end
