class AddAuthenticationToSmtpSettings < ActiveRecord::Migration
  def change
    add_column :irm_smtp_settings, :authentication, :string, :default => "login",:after=> :password
  end
end
