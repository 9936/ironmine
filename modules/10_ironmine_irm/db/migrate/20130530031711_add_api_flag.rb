class AddApiFlag < ActiveRecord::Migration
  def change
    add_column :irm_permissions, :api_flag, :string, :limit => 1, :default => 'N', :after => 'code', :null => false
    add_column :irm_functions, :api_flag, :string, :limit => 1, :default => 'N', :after => 'code', :null => false
    add_column :irm_function_groups, :api_flag, :string, :limit => 1, :default => 'N', :after => 'code', :null => false

    #更新视图
    execute('CREATE OR REPLACE VIEW irm_functions_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
             FROM irm_functions  t,irm_functions_tl tl WHERE t.id = tl.function_id')

    execute('CREATE OR REPLACE VIEW irm_function_groups_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
             FROM irm_function_groups t,irm_function_groups_tl tl WHERE t.id = tl.function_group_id')
  end
end
