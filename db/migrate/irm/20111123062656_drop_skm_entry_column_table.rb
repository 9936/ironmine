class DropSkmEntryColumnTable < ActiveRecord::Migration
  def up
    drop_table :skm_entry_columns
  end

  def down
  end
end
