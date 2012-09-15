class AddAssignPersonIdToSupportGroups < ActiveRecord::Migration
  def up
    add_column :icm_support_groups, "assign_person_id", :string,:limit=>22, :collate=>"utf8_bin",:after=>:assignment_process_code
    execute("CREATE OR REPLACE VIEW  icm_support_groups_vl  AS SELECT  t.*,tl.id as lang_id ,tl.name,tl.description,tl.language,tl.source_lang from (icm_support_groups t join irm_groups_tl tl) where (t.group_id = tl.group_id)")
  end

  def down
    remove_column :icm_support_groups, "assign_person_id"
    execute("CREATE OR REPLACE VIEW  icm_support_groups_vl  AS SELECT  t.*,tl.id as lang_id ,tl.name,tl.description,tl.language,tl.source_lang from (icm_support_groups t join irm_groups_tl tl) where (t.group_id = tl.group_id)")
  end
end
