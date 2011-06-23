class CreateMachineCodes < ActiveRecord::Migration
  def self.up
    create_table :machine_codes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :machine_codes
  end
end
