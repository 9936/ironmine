class RefreshViews < ActiveRecord::Migration
  def up
    execute('CREATE OR REPLACE VIEW com_config_classes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                             FROM com_config_classes t,com_config_classes_tl tl
                             WHERE t.id = tl.config_class_id')

    execute('CREATE OR REPLACE VIEW com_config_attributes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                             FROM com_config_attributes t,com_config_attributes_tl tl
                             WHERE t.id = tl.config_attribute_id')
  end

  def down
  end
end
