class ChangeEntryBooks < ActiveRecord::Migration
  def change
    add_column :skm_entry_books, :project_id, :string, :limit => 22, :collate => "utf8_bin", :after => :opu_id
    add_column :skm_entry_books, :project_name, :string, :collate => "utf8_bin", :after => :project_id
    add_column :skm_entry_books, :channel_id, :string, :collate => "utf8_bin", :after => :opu_id
  end
end
