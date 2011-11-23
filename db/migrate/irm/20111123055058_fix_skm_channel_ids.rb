class FixSkmChannelIds < ActiveRecord::Migration
  def up
    execute('DROP VIEW skm_channels_vl')
    change_column :skm_channels, :id, :string, :limit => 22, :null => false
    change_column :skm_channels_tl, :id, :string, :limit => 22, :null => false
    change_column :skm_channel_groups, :id, :string, :limit => 22, :null => false
    change_column :skm_channel_columns, :id, :string, :limit => 22, :null => false
    execute('CREATE OR REPLACE VIEW skm_channels_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM skm_channels  t,skm_channels_tl tl
                                                 WHERE t.id = tl.channel_id')
  end

  def down
    execute('DROP VIEW skm_channels_vl')
    change_column :skm_channels, :id, :integer, :limit => 11, :null => false
    change_column :skm_channels_tl, :id, :integer, :limit => 11, :null => false
    change_column :skm_channel_groups, :id, :integer, :limit => 11, :null => false
    change_column :skm_channel_columns, :id, :integer, :limit => 11, :null => false
    execute('CREATE OR REPLACE VIEW skm_channels_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM skm_channels  t,skm_channels_tl tl
                                                 WHERE t.id = tl.channel_id')
  end
end
