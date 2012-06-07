class AddDisplayColorToSkmStatus < ActiveRecord::Migration
  def change
    add_column :skm_entry_statuses, :display_color, :string, :after => :visiable_flag,:limit=>7
    execute('CREATE OR REPLACE VIEW skm_entry_statuses_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                               FROM skm_entry_statuses t,skm_entry_statuses_tl tl
                                               WHERE t.id = tl.entry_status_id')
  end
end
