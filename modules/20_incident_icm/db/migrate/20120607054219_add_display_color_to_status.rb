class AddDisplayColorToStatus < ActiveRecord::Migration
  def change
    add_column :icm_incident_statuses, :display_color, :string, :after => :display_sequence,:limit=>7
    execute('CREATE OR REPLACE VIEW icm_incident_statuses_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                                 FROM icm_incident_statuses t,icm_incident_statuses_tl tl
                                                 WHERE t.id = tl.incident_status_id')
  end
end
