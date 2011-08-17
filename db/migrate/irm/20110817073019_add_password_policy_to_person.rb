class AddPasswordPolicyToPerson < ActiveRecord::Migration
  def self.up
    add_column :irm_people,:password_updated_at,:datetime,:after=>:last_assigned_date
    add_column :irm_people,:locked_time,:integer,:default=>0,:after=>:last_assigned_date
    add_column :irm_people,:locked_until_at,:datetime,:after=>:last_assigned_date
  end

  def self.down
    remove_column :irm_people,:password_updated_at
    remove_column :irm_people,:locked_time
    remove_column :irm_people,:locked_until_at
  end
end
