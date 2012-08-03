class AddDisplayColorToChmStatus < ActiveRecord::Migration
  def change
    add_column :chm_change_statuses, :display_color, :string, :after => :display_sequence,:limit=>7
    execute('CREATE OR REPLACE VIEW chm_change_statuses_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                         FROM chm_change_statuses t,chm_change_statuses_tl tl
                         WHERE t.id = tl.change_status_id')
  end
end
