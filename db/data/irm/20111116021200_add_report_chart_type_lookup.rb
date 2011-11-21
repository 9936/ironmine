# -*- coding: utf-8 -*-
class AddReportChartTypeLookup < ActiveRecord::Migration
  def up
    report_chart_type=Irm::LookupType.new(:lookup_level=>'GLOBAL',:lookup_type=>'REPORT_CHART_TYPE',:status_code=>'ENABLED',:not_auto_mult=>true)
    report_chart_type.lookup_types_tls.build(:lookup_type_id=>report_chart_type.id,:meaning=>'报表图表类型',:description=>'报表图表类型',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    report_chart_type.lookup_types_tls.build(:lookup_type_id=>report_chart_type.id,:meaning=>'Report Chart Type',:description=>'Report Chart Type',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    report_chart_type.save

    irm_report_chart_typeline= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_CHART_TYPE',:lookup_code=>'LINE',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_chart_typeline.lookup_values_tls.build(:lookup_value_id=>irm_report_chart_typeline.id,:meaning=>'线形图',:description=>'线形图',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_chart_typeline.lookup_values_tls.build(:lookup_value_id=>irm_report_chart_typeline.id,:meaning=>'Line Chart',:description=>'Line Chart',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_chart_typeline.save
    irm_report_chart_typepie= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_CHART_TYPE',:lookup_code=>'PIE',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_chart_typepie.lookup_values_tls.build(:lookup_value_id=>irm_report_chart_typepie.id,:meaning=>'饼图',:description=>'饼图',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_chart_typepie.lookup_values_tls.build(:lookup_value_id=>irm_report_chart_typepie.id,:meaning=>'Pie Chart',:description=>'Pie Chart',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_chart_typepie.save
    irm_report_chart_typecolumn= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_CHART_TYPE',:lookup_code=>'COLUMN',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_chart_typecolumn.lookup_values_tls.build(:lookup_value_id=>irm_report_chart_typecolumn.id,:meaning=>'柱形图',:description=>'柱形图',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_chart_typecolumn.lookup_values_tls.build(:lookup_value_id=>irm_report_chart_typecolumn.id,:meaning=>'Column Chart',:description=>'Column Chart',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_chart_typecolumn.save
    irm_report_chart_typebar= Irm::LookupValue.new(:lookup_type=>'IRM_REPORT_CHART_TYPE',:lookup_code=>'BAR',:start_date_active=>'2011-05-12',:status_code=>'ENABLED',:not_auto_mult=>true)
    irm_report_chart_typebar.lookup_values_tls.build(:lookup_value_id=>irm_report_chart_typebar.id,:meaning=>'横向柱形图',:description=>'横向柱形图',:language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_chart_typebar.lookup_values_tls.build(:lookup_value_id=>irm_report_chart_typebar.id,:meaning=>'Horizontal Column Chart',:description=>'Horizontal Column Chart',:language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    irm_report_chart_typebar.save
  end

  def down
  end
end
