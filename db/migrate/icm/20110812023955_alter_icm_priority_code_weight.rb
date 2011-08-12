class AlterIcmPriorityCodeWeight < ActiveRecord::Migration
  def self.up
    remove_column :icm_priority_codes,:high_weight_value
    rename_column :icm_priority_codes,:low_weight_value,:weight_values
    execute('CREATE OR REPLACE VIEW icm_priority_codes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                       FROM icm_priority_codes t,icm_priority_codes_tl tl
                       WHERE t.id = tl.priority_code_id')
  end

  def self.down
    add_column :icm_priority_codes,:high_weight_value,:integer
    rename_column :icm_priority_codes,:weight_values ,:low_weight_value
     execute('CREATE OR REPLACE VIEW icm_priority_codes_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM icm_priority_codes t,icm_priority_codes_tl tl
                                             WHERE t.id = tl.priority_code_id')
  end
end
