class Csi::SurveysController < ApplicationController
  layout "bootstrap_application_full"
  # GET /surveys
  # GET /surveys.xml
  def index
    @surveys = Csi::Survey.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @surveys }
    end
  end

  # GET /surveys/1
  # GET /surveys/1.xml
  def show
    @survey = Csi::Survey.find(params[:id])

    respond_to do |format|
      format.html  # show.html.erb
      format.xml  { render :xml => @survey }
    end
  end

  # GET /surveys/new
  # GET /surveys/new.xml
  def new
    @survey = Csi::Survey.new(:status_code=>"OFFLINE")

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @survey }
    end
  end

  # GET /surveys/1/edit
  def edit
    @survey = Csi::Survey.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # POST /surveys
  # POST /surveys.xml
  def create
    @survey = Csi::Survey.new(params[:csi_survey])

    respond_to do |format|
      if @survey.save
        @survey.create_range_from_str
        format.html { redirect_to({:action=>"show",:id=>@survey.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @survey, :status => :created, :location => @survey }
      else
        format.html { render :action => "new"}
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /surveys/1
  # PUT /surveys/1.xml
  def update
    @survey = Csi::Survey.find(params[:id])
    respond_to do |format|
      if @survey.update_attributes(params[:csi_survey])
         @survey.create_range_from_str
        format.html { redirect_to({:action=>"show",:id=>@survey.id}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit"}
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.xml
  def destroy
    @survey = Csi::Survey.find(params[:id])
    @survey.destroy

    respond_to do |format|
      format.html { redirect_to(surveys_url) }
      format.xml  { head :ok }
    end
  end

  def get_data
    @surveys= Csi::Survey.list_all.with_person_count.order("created_at desc")
    @surveys = @surveys.match_value("#{Csi::Survey.table_name}.title",params[:title])
    @surveys,count = paginate(@surveys)
    @surveys_new = []
    @surveys.each do |s|
      s.person_count = Csi::SurveyRange.query_range_person_count(s.id)
      s.person_count = I18n.t(:unknow) if s.person_count == -1
      unless Irm::Constant::SYS_YES.eql?(s.publish_result_flag)
          s.publish_result_flag = s.current_author?
      end
      @surveys_new << s
    end
    respond_to do |format|
      format.json {render :json=>to_jsonp(@surveys_new.to_grid_json([:title,:description,:status_meaning, :joined_count, :person_count, :created_at,:publish_result_flag], count))}
      format.html {
        @count = count
        @datas = @surveys_new
      }
    end
  end 


  def show_reply
    @survey = Csi::Survey.find(params[:id])
    @survey_results = Csi::SurveyResult.list_all.where(:response_batch=>params[:survey_member_id])
  end

  def thanks
    @survey = Csi::Survey.find(params[:survey_id])
    @back_url=params[:back_url]
  end

  def show_result
    @survey_id = params[:id]
    survey = Csi::Survey.query(@survey_id).first
    @survey_code = survey.survey_code
    @survey_title = survey.title
    @subjects = Csi::SurveySubject.query_by_survey_id(@survey_id)
    @batch_results = Csi::SurveyResult.query_distinct_response_batch(@survey_id)

    respond_to do |format|
      format.html { render :layout => "application_full"}
    end
  end

  def export_result
    @survey_id = params[:id]
    @subjects = Csi::SurveySubject.query_by_survey_id(@survey_id)
    @batch_results = Csi::SurveyResult.query_distinct_response_batch(@survey_id)

    @export_results = Array.new
    @export_result = Hash.new
    @export_headers= Array.new
    
    survey_timestamps  = t(:label_csi_survey_timestamps)
    survey_person = t(:label_csi_survey_person)
    @export_headers << survey_timestamps
    @export_headers << survey_person    
    @subjects.each do |subject|
      @export_headers << subject.name
    end

    @batch_results.each do |batch_result|
      @export_result = {}
      @export_result = {survey_timestamps=>batch_result.response_time.to_time.to_formatted_s(:datetime_short),
                        survey_person=>Irm::Person.query_person_name(batch_result.person_id).first[:person_name]}
      @subjects.each do |subject|
        @export_result.merge!(subject.name=>get_survey_result(@survey_id,batch_result.response_batch,subject.id))
      end
      @export_results <<@export_result
    end

    respond_to do |format|
      format.html
      format.xls {send_data(@export_results.to_xls(:headers => @export_headers,:use_herders=>true)) }
    end
  end


  def test
    pei_hash = {"Monday"=>2000,"Tuesday"=>1000}
    @data_provider = to_pie_chart_json(pei_hash)
  end


  def get_survey_report
    incident_requests = Icm::IncidentRequest.query_by_urgency(I18n.locale)
    respond_to do |format|
      format.json {render :json=>to_jsonp(incident_requests.to_grid_json([:urgency_name,:urgency_count], 3))}
    end
  end

  def survey_report
    @survey_id = params[:id]
    survey = Csi::Survey.query(@survey_id).first
    @survey_code = survey.survey_code
    @survey_title = survey.title
    @return_url=request.env['HTTP_REFERER']
    render :layout => "application_full"
  end



  def active
    @survey = Csi::Survey.find(params[:id])
    attrs = {}
    if(Irm::Constant::SYS_YES.eql?(params[:active]))
      attrs =  {:status_code=>"ENABLED"}
    else
      attrs =  {:status_code=>"OFFLINE"}
    end

    respond_to do |format|
      if @survey.update_attributes(attrs)
        if @survey.enabled?
          @survey.generate_member
        else
          @survey.clear_member
        end
        format.html { redirect_to({:action=>"show",:id=>@survey.id}, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { redirect_to({:action=>"show",:id=>@survey.id}) }
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
    def get_survey_result(survey_id,response_batch,subject_id)
      @survey_result = Csi::SurveyResult.query_by_survey_id(survey_id,response_batch,subject_id)
      @count = Csi::SurveyResult.query_by_survey_id(survey_id,response_batch,subject_id).count
      @all_survey_result=""
      @survey_result.each do |t|
         if @count.to_i == 1
           @all_survey_result = t[:subject_result]
         else
           @all_survey_result = @all_survey_result + t[:subject_result]+','
         end
      end
      @all_survey_result
    end

    def to_pie_chart_json(chart_data)
      json = %Q([)
      if chart_data.is_a?(Hash)
        chart_data.each do |key,value|
          json << %Q({category:"#{key}",value:#{value}},)
        end
        json.chomp!(",")
      end
      json << "]"
      json
    end

end
