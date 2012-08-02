class AddDisplayColorToComStatus < ActiveRecord::Migration
  def change
    add_column :com_config_item_statuses, :display_color, :string, :after => :display_sequence,:limit=>7
    add_column :com_config_items, :config_item_status_id, :string, :after => :config_class_id,:limit => 22 , :collate=>"utf8_bin",:null=>false
    execute('CREATE OR REPLACE VIEW com_config_item_statuses_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                   FROM com_config_item_statuses t,com_config_item_statuses_tl tl
                                                   WHERE t.id = tl.config_item_status_id')
  end
end
