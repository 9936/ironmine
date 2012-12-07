class ChangeIncidentTransformsIndex < ActiveRecord::Migration
  def up
    remove_index :icm_status_transforms, :name => "IRM_STATUS_TRANSFORMS"
    add_index "icm_status_transforms", ["sid","from_status_id", "to_status_id"], :name => "IRM_STATUS_TRANSFORMS", :unique => true
  end

  def down
    remove_index :icm_status_transforms, :name => "IRM_STATUS_TRANSFORMS"
    add_index :icm_status_transforms, ["from_status_id", "to_status_id"], :name => "IRM_STATUS_TRANSFORMS", :unique => true
  end
end
