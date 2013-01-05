class AddAuthenticationToMailSettings < ActiveRecord::Migration
  def change
    add_column :irm_smtp_settings, :authentication_flag, :string, :limit => 1, :default => "Y",:after=> :authentication
  end
end
