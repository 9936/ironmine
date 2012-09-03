class CreateIcmSupportGroupVl < ActiveRecord::Migration
  def up
    execute('CREATE OR REPLACE VIEW icm_support_groups_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM icm_support_groups t,irm_groups_tl tl
                                             WHERE t.group_id = tl.group_id')
  end

  def down
    execute('DROP VIEW icm_support_groups_vl ')
  end
end
