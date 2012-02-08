class AddStatusCodeToPortlets < ActiveRecord::Migration
  def change
    add_column :irm_portlets, :status_code, :string , :limit => 30, :null => false,:after=> :default_flag

    execute('CREATE OR REPLACE VIEW irm_portlets_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM irm_portlets t,irm_portlets_tl tl
                         WHERE t.id = tl.portlet_id')
  end
end
