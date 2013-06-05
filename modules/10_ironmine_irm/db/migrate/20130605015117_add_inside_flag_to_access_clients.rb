class AddInsideFlagToAccessClients < ActiveRecord::Migration
  def change
    add_column :irm_oauth_access_clients, :inside_flag, :string, :limit => 1, :default => "N", :after => :site_url
  end
end
