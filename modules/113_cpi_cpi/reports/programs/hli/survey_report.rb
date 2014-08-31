class Hli::SurveyReport < Irm::ReportManager::ReportBase
  #重载data方法
  def data(params = {})
    params ||= {}
    datas = Csi::Survey.query_survey_by_day
    chart_datas = Csi::Survey.query_chart_data
    if(params[:date_from].present?)
      datas = datas.where("#{Csi::SurveyResponse.table_name}.created_at > ?",params[:date_from])
      chart_datas = chart_datas.where("#{Csi::SurveyResponse.table_name}.created_at > ?",params[:date_from])
    end
    if(params[:date_to].present?)
      datas = datas.where("#{Csi::SurveyResponse.table_name}.created_at < ?",params[:date_to])
      chart_datas = chart_datas.where("#{Csi::SurveyResponse.table_name}.created_at < ?",params[:date_to])
    end
    if(params[:survey_id].present?)
      datas = datas.where("#{Csi::Survey.table_name}.id = ?", params[:survey_id])
      chart_datas = chart_datas.where("#{Csi::Survey.table_name}.id = ?", params[:survey_id])
    end
    chart_datas_tmp = []
    chart_datas.each do |cd|
      chart_datas_tmp << cd.attributes
    end
    {:datas=>datas,:params=>params,:chart_datas=>chart_datas_tmp}
  end

  #重载to_xls方法
  def to_xls(params)
    columns = [{:key=>:title,:label=>I18n.t(:label_csi_survey_title)},
               {:key=>:total_count,:label=>I18n.t(:label_csi_survey_person_count)},
               {:key=>:date,:label=>I18n.t(:label_csi_survey_date)}]
    result = data(params)
    result[:datas].to_xls(columns,{}) do |sheet|
      chart_data_columns = [{:key=>:date,:label=>"Date"},
      {:key=>:total_count,:label=>"Total"}]
      result[:chart_datas].append_to_xls_sheet(sheet,chart_data_columns)
    end
  end

end
