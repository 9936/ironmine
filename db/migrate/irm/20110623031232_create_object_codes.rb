class CreateObjectCodes < ActiveRecord::Migration
  def self.up
    create_table :irm_object_codes do |t|
      t.string :company_id,:limit=>24,:null=>false
      t.string :object_table_name ,:null=>false
      t.string :object_code
      t.string  "created_by",:limit=>24,:null=>false
      t.string  "updated_by",:limit=>24,:null=>false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "irm_object_codes", ["object_table_name"],:unique=>true, :name => "IRM_OBJECT_CODES_U1"
    add_index "irm_object_codes", ["object_code"],:unique=>true, :name => "IRM_OBJECT_CODES_U2"


    create_table :irm_machine_codes do |t|
      t.string :company_id,:limit=>24,:null=>false
      t.string :machine_addr ,:null=>false,:limit=>17
      t.string :machine_code
      t.string  "created_by",:limit=>24,:null=>false
      t.string  "updated_by",:limit=>24,:null=>false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "irm_machine_codes", ["machine_addr"],:unique=>true, :name => "IRM_MACHINE_CODES_U1"
    add_index "irm_machine_codes", ["machine_code"],:unique=>true, :name => "IRM_MACHINE_CODES_U2"
  end

  def self.down
    drop_table :irm_object_codes
    drop_table :irm_machine_codes
  end
end
