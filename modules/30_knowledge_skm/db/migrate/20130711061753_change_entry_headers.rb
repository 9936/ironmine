class ChangeEntryHeaders < ActiveRecord::Migration
  def change
    add_column :skm_entry_headers, :project_id, :string, :limit => 22, :collate => "utf8_bin", :after => :channel_id
    add_column :skm_entry_headers, :project_name, :string, :collate => "utf8_bin", :after => :project_id
  end
end
