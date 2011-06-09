class RemoveOldColumnFromIcmGroupAssignment < ActiveRecord::Migration
  def self.up
    remove_column :icm_group_assignments, :customer_company_id
    remove_column :icm_group_assignments, :customer_organization_id
    remove_column :icm_group_assignments, :customer_department_id
    remove_column :icm_group_assignments, :customer_site_group_code
    remove_column :icm_group_assignments, :customer_site_code
    remove_column :icm_group_assignments, :customer_person_id
    remove_column :icm_group_assignments, :assign_type
    remove_column :icm_group_assignments, :service_code
    remove_column :icm_group_assignments, :external_system_code
  end

  def self.down
    add_column :icm_group_assignments, :customer_company_id, :integer, :after => :company_id
    add_column :icm_group_assignments, :customer_organization_id, :integer, :after => :company_id
    add_column :icm_group_assignments, :customer_department_id, :integer, :after => :company_id
    add_column :icm_group_assignments, :customer_site_group_code, :string, :limit =>30, :after => :company_id
    add_column :icm_group_assignments, :customer_site_code, :string, :limit => 30, :after => :company_id
    add_column :icm_group_assignments, :customer_person_id, :integer, :after => :company_id
    add_column :icm_group_assignments, :assign_type, :string, :limit => 30, :after => :company_id
    add_column :icm_group_assignments, :service_code, :string, :limit => 30, :after => :company_id
    add_column :icm_group_assignments, :external_system_code, :string, :limit => 30, :after => :company_id
  end
end
