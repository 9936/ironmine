class CreateLdapAuthRules < ActiveRecord::Migration
  def change
    create_table :irm_ldap_auth_rules do |t|
      t.string   "ldap_auth_header_id", :limit => 22,  :null => false, :collate => "utf8_bin"
      t.string   "opu_id",        :limit => 22, :null => false, :collate=>"utf8_bin"
      t.string   "attr_field",          :limit => 60,  :null => false
      t.string   "operator_code", :limit => 30
      t.string   "attr_value",     :limit => 60,  :null => false
      t.string   "template_person_id", :limit => 22
      t.integer  "sequence",      :default => 1
      t.string   "status_code",   :limit => 30, :null => false
      t.string   "created_by",    :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",    :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :irm_ldap_auth_rules, "id", :string,:limit=>22, :collate=>"utf8_bin"
  end
end
