class Csi::SurveyResultsController < ApplicationController
  def statistics
    @survey = Csi::Survey.find(params[:id])
    respond_to do |format|
      format.html {render :layout => "application_full"}
    end
  end

  def export
    @survey = Csi::Survey.find(params[:id])
    respond_to do |format|
      #根据当前的调查名称和当前的时间组成当前要导出的Excel 名称
      format.xls { send_data(export_survey_data_to_excel(@survey),:type => "text/plain", :filename=>"#{@survey.title}_#{Time.now.strftime('%Y%m%d%H%M%S')}.xls") }
    end
  end

  def list
    @survey = Csi::Survey.find(params[:id])

    respond_to do |format|
      format.html {render :layout => "application_full"}
    end
  end

  def get_data
    survey_responses_scope = Csi::SurveyResponse.list_all.where(:survey_id=>params[:id])
    survey_responses_scope = survey_responses_scope.match_value("#{Irm::Person.table_name}.full_name",params[:person_name])
    survey_responses,count = paginate(survey_responses_scope)
    respond_to do |format|
      format.json {render :json=>to_jsonp(survey_responses.to_grid_json([:person_name,:start_at,:elapse,:ip_address],count))}
      format.html {
        @count = count
        @survey_data = survey_results(survey_responses, "<br />")
        @survey_subjects = survey_subjects(params[:id])
      }
    end
  end

  def show_input
    @survey_subject = Csi::SurveySubject.find(params[:id])
    @text_inputs = Csi::SurveyResult.select_all.with_response.where("result_type IN (?)",["OTHER","INPUT"]).where(:survey_subject_id=>params[:id])
  end


  def show_response
    @survey_response = Csi::SurveyResponse.find(params[:id])
    respond_to do |format|
      format.html {render :layout => "application_full"}
    end
  end

  private
    def export_survey_data_to_excel(survey)
      #参与该调查问卷相关的人员信息
      survey_data = Csi::SurveyResponse.find_by_sql "SELECT sr.*, p.full_name person_name FROM #{Csi::SurveyResponse.table_name} sr LEFT JOIN #{Irm::Person.table_name} p ON sr.person_id=p.id WHERE sr.survey_id='#{survey.id}'"

      #定义列标题
      columns = [{:key=>:person_name,:label=>t(:label_csi_survey_response_person)},
                 {:key=>:start_at,:label=>t(:label_csi_survey_response_start_at)},
                 {:key=>:elapse,:label=>t(:label_csi_survey_response_elapse)},
                 {:key=>:ip_address,:label=>t(:label_csi_survey_response_ip_address)}]
      #查询出所有的问卷题目
      survey_subjects = survey_subjects(survey.id)
      #将题目添加到Excel列标题
      survey_subjects.each do |s|
        columns<<{:key=>s[:id],:label=>s[:name]}
      end
      data_to_xls(survey_results(survey_data),columns)
    end

    #根据调查的项目获取相应的调查结果
    def survey_results(survey_data,line_format="\n")
      response_ids = survey_data.collect{ |i| i.id }
      results = Csi::SurveyResult.select_all.with_option.where(:survey_response_id=>response_ids)
      #将results按照survey_response_id进行分组
      tmp_data = {}
      results.each do |r|
        tmp_data[r.survey_response_id] ||= []
        tmp_data[r.survey_response_id] << r
      end
      survey_data.each do |sd|
         tmp_data[sd[:id]].each do |option|
           current_option = ""
           if "OPTION".eql?(option.result_type)
             current_option = option[:option_value]
           elsif "INPUT".eql?(option.result_type)
             current_option = option[:text_input]
           elsif "OTHER".eql?(option.result_type)
             current_option = "#{t(:label_csi_survey_subjects_other)}:#{option[:text_input]}"
           end
           sd[option.survey_subject_id] = sd[option.survey_subject_id].present?? "#{sd[option.survey_subject_id]}#{line_format} #{current_option}" : "#{current_option}"
         end
      end
      survey_data
    end

    def survey_subjects(survey_id)
      Csi::SurveySubject.select("id, name").where(:survey_id => survey_id)
    end
end
