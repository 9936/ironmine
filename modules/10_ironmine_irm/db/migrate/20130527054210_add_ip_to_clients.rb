class AddIpToClients < ActiveRecord::Migration
  def change
    add_column :irm_oauth_access_clients, :ip, :string, :limit => 30, :after => :site_url
  end
end
