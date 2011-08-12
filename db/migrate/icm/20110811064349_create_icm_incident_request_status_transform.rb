class CreateIcmIncidentRequestStatusTransform < ActiveRecord::Migration
  def self.up
    create_table :icm_status_transforms,:force=>true do |t|
      t.string   :company_id,:limit=>22, :null => false
      t.string   :from_status_id,:limit=>22, :null => false
      t.string   :to_status_id,:limit=>22, :null => false
      t.string   :event_code,:limit=>30, :null => false
      t.string   :status_code, :limit => 30,  :null => false,:default=>"ENABLED"
      t.string   :created_by,:limit=>22,:null=>false
      t.string   :updated_by,:limit=>22,:null=>false
      t.datetime :created_at
      t.datetime :updated_at
    end
    change_column :icm_status_transforms, :id, :string,:limit=>22, :null => false,:collate=>"utf8_bin"
    add_index "icm_status_transforms", ["from_status_id", "to_status_id"],:unique=>true, :name => "IRM_STATUS_TRANSFORMS"

  end

  def self.down
    drop_table :icm_status_transforms
  end
end
