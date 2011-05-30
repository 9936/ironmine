class AddServiceToGroupAssignment < ActiveRecord::Migration
  def self.up
    add_column :icm_group_assignments, :external_system_code, :string ,:limit => 30, :after => "customer_person_id"
    add_column :icm_group_assignments, :service_code, :string ,:limit => 30, :after => "customer_person_id"
    add_column :icm_group_assignments, :assign_type, :string, :limit => 30, :after => "customer_person_id"
  end

  def self.down
    remove_column :icm_group_assignments, :external_system_code
    remove_column :icm_group_assignments, :service_code
    remove_column :icm_group_assignments, :assign_type
  end
end
