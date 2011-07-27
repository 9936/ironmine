class Irm::ReportsController < ApplicationController
  def index
    @folder_id = params[:folder_id]
  end

  def new
    if params[:irm_report]
      session[:irm_report].merge!(params[:irm_report].symbolize_keys)
    else
      session[:irm_report]={:step=>1}
    end
    @report = Irm::Report.new(session[:irm_report])
    @report.step = @report.step.to_i if  @report.step.present?

    if(@report.step<2)
      @report.not_auto_mult = true
    end
    validate_result =  request.post?&&@report.valid?
    # validate filter
    #if request.post?&&@report.step.eql?(2)
    #  session[:irm_rule_filter] = params[:irm_rule_filter]
    # @rule_filter = Irm::RuleFilter.new(session[:irm_rule_filter])
    #  validate_result = validate_result&&@rule_filter.valid?
    #  @wf_approval_step.evaluate_mode = "FILTER" unless @rule_filter.valid?
    #end

    if validate_result
      if(params[:pre_step])&&@report.step>1
        @report.step = @report.step.to_i-1
        session[:irm_report][:step] = @report.step
      else
        if @report.step<5
          @report.step = @report.step.to_i+1
          session[:irm_report][:step] = @report.step
        end
      end
    end

    #prepare step 4
    if validate_result&&@report.step.eql?(4)
      @report.prepare_group_column
    end

    #prepare step 5
    if validate_result&&@report.step.eql?(5)
      @report.prepare_criterions
    end

    #if @report.next_approver_mode.present?
    #  @report.approver_mode ||= "PROCESS_DEFAULT"
    #end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report }
    end
  end

  def create
    session[:irm_report].merge!(params[:irm_report].symbolize_keys)
    @report = Irm::Report.new(session[:irm_report])

    respond_to do |format|
      if @report.valid?
         @report.create_columns_from_str
         @report.save
         session[:irm_report] = nil
        format.html { redirect_to({:action=>"show",:id=>@report.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @report, :status => :created, :location => @wf_rule }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @report = Irm::Report.multilingual.with_report_type(I18n.locale).find(params[:id])
    if params[:irm_report]
      session[:irm_report].merge!(params[:irm_report].symbolize_keys)
    else
      session[:irm_report]={:step=>2}
    end
    @report.attributes = session[:irm_report]
    @report.step = @report.step.to_i if  @report.step.present?

    validate_result =  request.put?&&@report.valid?
    # validate filter
    #if request.post?&&@report.step.eql?(2)
    #  session[:irm_rule_filter] = params[:irm_rule_filter]
    # @rule_filter = Irm::RuleFilter.new(session[:irm_rule_filter])
    #  validate_result = validate_result&&@rule_filter.valid?
    #  @wf_approval_step.evaluate_mode = "FILTER" unless @rule_filter.valid?
    #end

    if validate_result
      if(params[:pre_step])&&@report.step>1
        @report.step = @report.step.to_i-1
        session[:irm_report][:step] = @report.step
      else
        if @report.step<5
          @report.step = @report.step.to_i+1
          session[:irm_report][:step] = @report.step
        end
      end
    end


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report }
    end
  end

  def update
    @report = Irm::Report.multilingual.find(params[:id])
    session[:irm_report].merge!(params[:irm_report].symbolize_keys)
    @report.attributes =  session[:irm_report]

    respond_to do |format|
      if @report.valid?
         @report.create_columns_from_str
         @report.save
         session[:irm_report] = nil
        format.html { redirect_to({:action=>"show",:id=>@report.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @report, :status => :created, :location => @wf_rule }
      else
        format.html { render({:action=>"show",:id=>@report.id}) }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  def operator_value
    @field_id = params[:field_id]
    @report_criterion = Irm::ReportCriterion.new(:seq_num=>params[:seq_num])
    num = (params[:seq_num]||1).to_i-1
    @named_form = "irm_report[report_criterions_attributes][#{num}]"
  end

  def show
    folder_ids = Irm::Person.current.report_folders.collect{|i| i.id}
    @report = Irm::Report.multilingual.query_by_folders(folder_ids).with_report_type(I18n.locale).with_report_folder(I18n.locale).filter_by_folder_access(Irm::Person.current.id).find(params[:id])

    @filter_date_from=""
    @filter_date_to=""
    @filter_date_from = @report.filter_date_from.strftime("%Y-%m-%d") if @report.filter_date_from.present?
    @filter_date_to = @report.filter_date_to.strftime("%Y-%m-%d") if @report.filter_date_to.present?
  end

  def run
    @report = Irm::Report.multilingual.find(params[:id])
    @report.attributes =  params[:irm_report]
    @filter_date_from=""
    @filter_date_to=""
    @filter_date_from = @report.filter_date_from.strftime("%Y-%m-%d") if @report.filter_date_from.present?
    @filter_date_to = @report.filter_date_to.strftime("%Y-%m-%d") if @report.filter_date_to.present?
    render :action=>"show"
  end


  def get_data
    folder_ids = []
    if params[:folder_id].present?
      folder_ids = [params[:folder_id]]
    else
      folder_ids = Irm::Person.current.report_folders.collect{|i| i.id}
    end
    reports_scope = Irm::Report.multilingual.query_by_folders(folder_ids).with_report_type(I18n.locale).with_report_folder(I18n.locale).filter_by_folder_access(Irm::Person.current.id)
    reports_scope,count = paginate(reports_scope)
    reports_scope.each do |i|
      i[:editable_flag] = i.editable(i[:member_type],i[:access_type],Irm::Person.current.id)
    end
    respond_to do |format|
      format.json {render :json=>to_jsonp(reports_scope.to_grid_json([:name,
                                                                      :editable_flag,
                                                                      :code,:report_folder_name,
                                                                      :report_type_name,
                                                                      :description],count))}
    end
  end


  def destroy
    @report = Irm::Report.find(params[:id])
    @report.destroy
    folder_id = @report.report_folder_id
    respond_to do |format|
      format.html { redirect_to({:action=>"index",:folder_id=>folder_id}) }
      format.xml  { head :ok }
    end
  end


  def edit_custom
    @report = Irm::Report.multilingual.with_report_type(I18n.locale).find(params[:id])
    if params[:irm_report]&&params[:irm_report][:step].present?
      session[:irm_report].merge!(params[:irm_report].symbolize_keys)
      @report.attributes = session[:irm_report]
    else
      session[:irm_report]={:step=>2,:name=>nil,:description=>nil,:code=>nil,:report_type_id=>@report.report_type_id}
      @report.attributes = session[:irm_report]
      @report[:name] = nil
    end

    @report.step = @report.step.to_i if  @report.step.present?
    validate_result = false
    if(@report.step>2)
      validate_result =  request.put?&&params[:irm_report][:step].present?&&@report.valid?
    else
      temp_id = @report.clear_id
      validate_result =  request.put?&&params[:irm_report][:step].present?&&@report.valid?
      @report.set_id(temp_id)
    end
    # validate filter
    #if request.post?&&@report.step.eql?(2)
    #  session[:irm_rule_filter] = params[:irm_rule_filter]
    # @rule_filter = Irm::RuleFilter.new(session[:irm_rule_filter])
    #  validate_result = validate_result&&@rule_filter.valid?
    #  @wf_approval_step.evaluate_mode = "FILTER" unless @rule_filter.valid?
    #end

    if validate_result
      if(params[:pre_step])&&@report.step>2
        @report.step = @report.step.to_i-1
        session[:irm_report][:step] = @report.step
      else
        if @report.step<5
          @report.step = @report.step.to_i+1
          session[:irm_report][:step] = @report.step
        end
      end
    end


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report }
    end
  end

  def update_custom
    session[:irm_report].merge!(params[:irm_report].symbolize_keys)
    puts session[:irm_report][:report_group_columns_attributes].class
    session[:irm_report][:report_group_columns_attributes].each{|key,value| value[:id]=nil}
    session[:irm_report][:report_criterions_attributes].each{|key,value| value[:id]=nil}
    @report = Irm::Report.new(session[:irm_report])

    respond_to do |format|
      if @report.valid?
         @report.create_columns_from_str
         @report.save
         session[:irm_report] = nil
        format.html { redirect_to({:action=>"show",:id=>@report.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @report, :status => :created, :location => @wf_rule }
      else
        puts @report.errors
        format.html { render :action => "edit_custom" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end
end
