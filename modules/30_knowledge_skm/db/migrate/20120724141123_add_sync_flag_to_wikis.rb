class AddSyncFlagToWikis < ActiveRecord::Migration
  def change
    add_column :skm_wikis, :sync_flag, :string, :after => :entry_status_code,:limit=>1,:default=>"N"
 end
end
