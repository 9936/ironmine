class ModifyExternalSystemFunctions < ActiveRecord::Migration
  def self.up
    Irm::FunctionGroup.where(:code => "SYSTEM").each do |t|
      t.update_attribute(:controller, "irm/external_systems")
    end

    Irm::FunctionGroup.where(:code => "EXTERNAL_SYSTEM_MEMBER").each do |t|
      t.update_attribute(:controller, "irm/external_system_members")
    end
  end

  def self.down
    Irm::FunctionGroup.where(:code => "SYSTEM").each do |t|
      t.update_attribute(:controller, "uid/external_systems")
    end

    Irm::FunctionGroup.where(:code => "EXTERNAL_SYSTEM_MEMBER").each do |t|
      t.update_attribute(:controller, "uid/external_system_members")
    end
  end
end
