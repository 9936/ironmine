class RenameReportTables < ActiveRecord::Migration
  def self.up
    #rename_table(:irm_reports,:irm_x_reports)
    #rename_table(:irm_reports_tl,:irm_x_reports_tl)
    execute('CREATE OR REPLACE VIEW irm_x_reports_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_x_reports t,irm_x_reports_tl tl
                                             WHERE t.id = tl.report_id')
    execute('drop view irm_reports_vl')
  end

  def self.down
    rename_table(:irm_x_reports,:irm_reports)
    rename_table(:irm_x_reports_tl,:irm_reports_tl)
    execute('CREATE OR REPLACE VIEW irm_reports_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_reports t,irm_reports_tl tl
                                             WHERE t.id = tl.report_id')
    execute('drop view irm_x_reports_vl')
  end
end
