class CreateSkmWikiTemplates < ActiveRecord::Migration
  def change
    create_table :skm_wiki_templates do |t|
      t.string   "opu_id",            :limit => 22 , :collate=>"utf8_bin"
      t.string   "name",              :limit => 150
      t.string   "description",       :limit => 240
      t.text     "content"
      t.string   "content_format",    :limit => 30
      t.string   "private_flag",      :limit => 1,:default=>"N"
      t.string   "created_by",        :limit => 22, :collate=>"utf8_bin"
      t.string   "updated_by",        :limit => 22, :collate=>"utf8_bin"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    change_column :skm_wiki_templates, "id", :string,:limit=>22, :collate=>"utf8_bin"
    add_column :skm_wikis,:num,:string,:limit => 30,:after=>:name
    add_column :skm_wikis,:tags,:string,:limit => 150,:after=>:name
    add_column :skm_wikis,:channel_id,:string,:limit => 22, :collate=>"utf8_bin",:after=>:name
    add_column :skm_wikis,:entry_status_code,:string,:limit => 30,:after=>:content_format
    add_column :skm_wikis,:source_id,:string,:limit => 22, :collate=>"utf8_bin",:after=>:content_format
    add_column :skm_wikis,:source_type,:string,:limit => 60,:after=>:content_format
    add_column :skm_wikis,:private_flag,:string,:limit => 1,:default=>"N",:after=>:content_format
  end
end
