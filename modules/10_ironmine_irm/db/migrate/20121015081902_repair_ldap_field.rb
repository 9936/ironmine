class RepairLdapField < ActiveRecord::Migration
  def up
    add_column :irm_ldap_sources,:account_password, :string, :limit => 60, :after => "base_dn"
    add_column :irm_ldap_sources,:account, :string, :limit => 150, :after=> "base_dn"
  end

  def down
    remove_column :irm_ldap_sources,:account
    remove_column :irm_ldap_sources,:account_password
  end
end
