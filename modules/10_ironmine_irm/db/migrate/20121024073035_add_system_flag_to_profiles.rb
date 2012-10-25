class AddSystemFlagToProfiles < ActiveRecord::Migration
  def change
    add_column :irm_profiles, :system_flag, :string, :limit => 1, :default => 'N', :after => 'code', :null => false
    execute('CREATE OR REPLACE VIEW irm_profiles_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
             FROM irm_profiles t,irm_profiles_tl tl WHERE t.id = tl.profile_id')
  end
end
