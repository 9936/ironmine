class AddReportChartTypeToIrmReports < ActiveRecord::Migration
  def up
    add_column :irm_reports,:chart_type,:string,:limit=>30,:after=>:program_type
    execute('CREATE OR REPLACE VIEW irm_reports_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_reports t,irm_reports_tl tl
                                             WHERE t.id = tl.report_id')
  end

  def down
    remove_column :irm_reports,:chart_type
    execute('CREATE OR REPLACE VIEW irm_reports_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_reports t,irm_reports_tl tl
                                             WHERE t.id = tl.report_id')
  end
end
