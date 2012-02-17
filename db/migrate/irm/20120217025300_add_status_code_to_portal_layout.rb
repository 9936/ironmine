class AddStatusCodeToPortalLayout < ActiveRecord::Migration
  def change
    add_column :irm_portal_layouts, :status_code, :string , :limit => 30, :null => false,:after=> :default_flag
     execute('CREATE OR REPLACE VIEW irm_port_layouts_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM irm_port_layouts t,irm_port_layouts_tl tl
                         WHERE t.id = tl.portal_layout_id')
  end
end
