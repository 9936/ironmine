class AddExternalSystemIdToAssignRules < ActiveRecord::Migration
  def change
    Icm::AssignRule.all.map(&:destroy)
    add_column :icm_assign_rules, :external_system_id, :string, :limit=>22, :collate=>"utf8_bin",:after => "opu_id"
  end
end
