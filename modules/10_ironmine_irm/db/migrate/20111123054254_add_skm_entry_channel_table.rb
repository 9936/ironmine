class AddSkmEntryChannelTable < ActiveRecord::Migration
  def up
    add_column :skm_entry_headers, :channel_id, :string, :limit => 22, :after => :opu_id
  end

  def down
    remove_column :skm_entry_headers, :channel_id
  end
end
