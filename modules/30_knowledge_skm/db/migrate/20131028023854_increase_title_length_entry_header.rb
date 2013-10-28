class IncreaseTitleLengthEntryHeader < ActiveRecord::Migration
  def change
    change_column :skm_entry_headers, "entry_title", :string,:limit=>150
  end
end
