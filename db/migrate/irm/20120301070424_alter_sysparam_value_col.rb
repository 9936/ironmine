class AlterSysparamValueCol < ActiveRecord::Migration
  def up
    remove_column :irm_system_parameters, :value,:img_updated_at ,:img_file_size,:img_content_type, :img_file_name
     execute('CREATE OR REPLACE VIEW irm_system_parameters_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                 FROM irm_system_parameters t,irm_system_parameters_tl tl
                                 WHERE t.id = tl.system_parameter_id')
  end

  def down
  end
end
