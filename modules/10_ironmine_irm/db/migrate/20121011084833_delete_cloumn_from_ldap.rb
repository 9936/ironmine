class DeleteCloumnFromLdap < ActiveRecord::Migration
  def up
    remove_column :irm_ldap_sources,:account
    remove_column :irm_ldap_sources,:account_password
  end

  def down
    add_column :irm_ldap_sources,:account, :limit => 60, :null => false
    add_column :irm_ldap_sources,:account_password, :limit => 60, :null => false
  end
end
