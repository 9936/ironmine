class AddProgramReportColumn < ActiveRecord::Migration
  def up
    add_column :irm_reports,:program_type,:string,:limit=>30,:default=>"CUSTOM",:after=>:code
    add_column :irm_reports,:program_params,:text,:after=>:program_type
    add_column :irm_reports,:programs,:string,:limit=>60,:after=>:code
    remove_column :irm_reports,:filter_company_id
    change_column :irm_reports,:report_type_id,:string,:limit=>22 ,:null=>true
    execute('CREATE OR REPLACE VIEW irm_reports_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_reports t,irm_reports_tl tl
                                             WHERE t.id = tl.report_id')
  end

  def down
    remove_column :irm_reports,:program_type
    remove_column :irm_reports,:program_params
    remove_column :irm_reports,:programs
    add_column :irm_reports,:filter_company_id,:string,:limit=>22
    execute('CREATE OR REPLACE VIEW irm_reports_vl AS SELECT t.*,tl.id lang_id,tl.name,tl.description,tl.language,tl.source_lang
                                             FROM irm_reports t,irm_reports_tl tl
                                             WHERE t.id = tl.report_id')
  end
end
