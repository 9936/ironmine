class ChangeDataAccessLevelLookup < ActiveRecord::Migration
  def up
    lookup_values = Irm::LookupValue.where(:lookup_type=>"IRM_DATA_ACCESS_LEVEL")
    changes = {"PRIVATE_PERSONAL"=>"0","PUBLIC_READ"=>"1","PUBLIC_READ_WRITE"=>"2"}
    lookup_values.each do |value|
      value.update_attribute(:lookup_code,changes[value.lookup_code]) if changes[value.lookup_code].present?
    end

    changes.each do |from,to|
      Irm::DataAccess.where(:access_level=>from).update_all(:access_level=>to)
      Irm::DataShareRule.where(:access_level=>from).update_all(:access_level=>to)
    end

  end

  def down
  end
end
