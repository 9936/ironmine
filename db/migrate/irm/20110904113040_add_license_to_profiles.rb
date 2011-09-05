class AddLicenseToProfiles < ActiveRecord::Migration
  def self.up
    add_column :irm_operation_units,:license_id,:string,:limit=>22,:after=>:primary_person_id
    execute('CREATE OR REPLACE VIEW irm_operation_units_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_operation_units t,irm_operation_units_tl tl
                                                 WHERE t.id = tl.operation_unit_id')
  end

  def self.down
    remove_column :irm_operation_units,:license_id
    execute('CREATE OR REPLACE VIEW irm_operation_units_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM irm_operation_units t,irm_operation_units_tl tl
                                                 WHERE t.id = tl.operation_unit_id')
  end
end
