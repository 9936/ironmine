class AddSystemProfileToSystemMembers < ActiveRecord::Migration
  def change
    add_column :irm_external_system_people, :system_profile_id, :string,:limit=>22, :collate=>"utf8_bin",:after => "external_system_id"
  end
end
