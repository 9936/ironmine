class CreateStatusTransforms < ActiveRecord::Migration
  def self.up
    create_table :status_transforms do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :status_transforms
  end
end
