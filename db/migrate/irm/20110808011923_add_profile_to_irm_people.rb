class AddProfileToIrmPeople < ActiveRecord::Migration
  def self.up
    add_column :irm_people,:profile_id,:string,:limit=>22,:after=>:department_id
    add_column :irm_people,:role_id,:string,:limit=>22,:after=>:department_id
  end

  def self.down
    remove_column :irm_people,:profile_id
    remove_column :irm_people,:role_id
  end
end
