class Csi::SurveySubjectsController < ApplicationController
  layout "bootstrap_application_full"
  # GET /survey_subjects/1
  # GET /survey_subjects/1.xml
  def show
    @survey_subject = Csi::SurveySubject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @survey_subject }
    end
  end

  # GET /survey_subjects/new
  # GET /survey_subjects/new.xml
  def new
    @survey_subject = Csi::SurveySubject.new(:survey_id=>params[:survey_id],:input_type=>'string',:display_sequence=>Csi::SurveySubject.get_max_display_sequence(params[:survey_id]))
    @survey = Csi::Survey.find(params[:survey_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @survey_subject }
    end
  end

  # GET /survey_subjects/1/edit
  def edit
    @survey_subject = Csi::SurveySubject.find(params[:id])
    @survey = Csi::Survey.find(@survey_subject.survey_id)
  end

  # POST /survey_subjects
  # POST /survey_subjects.xml
  def create
    @survey_subject = Csi::SurveySubject.new(params[:csi_survey_subject])
    subject_options= params[:options]
    commit = params[:commit]

    respond_to do |format|
      if @survey_subject.valid?
        if subject_options.present?
           @survey_subject.generate_options(subject_options)
        end
        @survey_subject.save
        if params[:save_and_new].present?
          format.html { redirect_to({:action=>"new",:survey_id=>@survey_subject.survey_id},
                                    :notice => t(:successfully_created)) }
        else
          format.html { redirect_to({:controller=>"csi/surveys",:action=>"show",
                                     :id=>@survey_subject.survey_id}, :notice => t(:successfully_created)) }
        end
        format.xml  { render :xml => @survey_subject, :status => :created, :location => @survey_subject }
      else
        format.html { render :action => "new", :layout => "application_full" }
        format.xml  { render :xml => @survey_subject.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /survey_subjects/1
  # PUT /survey_subjects/1.xml
  def update
    @survey_subject = Csi::SurveySubject.find(params[:id])
    @subject_options= params[:options]
    @return_url= params[:return_url]
    @survey_id= params[:survey_id]

    respond_to do |format|
      if @survey_subject.update_attributes(params[:csi_survey_subject])
        #删除原来的数据，替换现在的数据
        Csi::SubjectOption.delete_by_subject(@survey_subject.id)
        if @subject_options
          @subject_options.each do |option|
             @survey_subject.subject_options.create({:value=>option})
          end
        end
        format.html { redirect_to(@return_url, :notice => t(:successfully_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @survey_subject.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.xml
  def destroy
    @survey_subject = Csi::SurveySubject.find(params[:id])
    @survey_id = @survey_subject.survey_id
    @survey_subject.destroy

    respond_to do |format|
      format.html { redirect_to({:controller=>"csi/surveys",:action=>"show",
                                 :id=>@survey_id}) }
      format.xml  { head :ok }
    end
  end

  def get_data
    @survey_subjects= Csi::SurveySubject.query_by_survey_id(params[:id]).order_by_seq_num
    @survey_subjects,count = paginate(@survey_subjects)
    respond_to do |format|
      format.json {render :json=>to_jsonp(@survey_subjects.to_grid_json(['R',:seq_num,:name,:prompt,:required_flag], count))}
    end
  end
end
