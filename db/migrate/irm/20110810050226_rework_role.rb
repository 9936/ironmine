class ReworkRole < ActiveRecord::Migration
  def self.up
    drop_table :irm_person_roles if table_exists?(:irm_person_roles)
    drop_table :irm_role_functions if table_exists?(:irm_role_functions)

    remove_column :irm_roles,:kanban_id
    rename_column :irm_roles,:role_code,:code
    remove_column :irm_roles,:report_group_code
    remove_column :irm_roles,:hidden_flag
    remove_column :irm_roles,:menu_code
    remove_column :irm_roles,:service_role_type
    add_column :irm_roles,:report_to_role_id,:string,:limit=>22 ,:after=>:code
    execute('CREATE OR REPLACE VIEW irm_roles_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_roles  t,irm_roles_tl tl
                                             WHERE t.id = tl.role_id')
  end

  def self.down
    add_column :irm_roles,:kanban_id,:string,:limit=>22
    rename_column :irm_roles,:code,:role_code
    add_column :irm_roles,:report_group_code,:string,:limit=>30
    add_column :irm_roles,:hidden_flag ,:string,:limit=>1
    add_column :irm_roles,:menu_code,:string,:limit=>30
    add_column :irm_roles,:service_role_type,:string,:limit=>30
    remove_column :irm_roles,:report_to_role_id
    execute('CREATE OR REPLACE VIEW irm_roles_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_roles  t,irm_roles_tl tl
                                             WHERE t.id = tl.role_id')
  end
end
