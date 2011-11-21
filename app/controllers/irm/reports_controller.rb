class Irm::ReportsController < ApplicationController
  def index
    @folder_id = params[:folder_id]

    respond_to do |format|
      format.html { render :layout => "application_full"}# index.html.erb
    end
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
      format.html { render :layout => "application_full"}# index.html.erb
    end
  end

  def create
    session[:irm_report].merge!(params[:irm_report].symbolize_keys)
    @report = Irm::Report.new(session[:irm_report])

    respond_to do |format|
      if @report.valid?
         @report.sync_custom_report_params
         @report.create_columns_from_str
         @report.save
         session[:irm_report] = nil
        format.html { redirect_to({:action=>"show",:id=>@report.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @report, :status => :created, :location => @wf_rule }
      else
        format.html { render :action => "new", :layout => "application_full" }
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
      if(params[:pre_step])&&@report.step>2
        @report.step = @report.step.to_i-1
        session[:irm_report][:step] = @report.step
      else
        if params[:pre_step].nil?&&@report.step<5
          @report.step = @report.step.to_i+1
          session[:irm_report][:step] = @report.step
        end
      end
    end


    respond_to do |format|
      format.html { render :layout => "application_full"}# index.html.erb
    end
  end

  def update
    @report = Irm::Report.find(params[:id])
    session[:irm_report].merge!(params[:irm_report].symbolize_keys)
    @report.attributes =  session[:irm_report]

    respond_to do |format|
      if @report.valid?
         @report.sync_custom_report_params
         @report.create_columns_from_str
         @report.save
         session[:irm_report] = nil
        format.html { redirect_to({:action=>"show",:id=>@report.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @report, :status => :created, :location => @wf_rule }
      else
        format.html { render({:action=>"edit",:id=>@report.id}, :layout => "application_full") }
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
    render :action=>"show",:layout=>"application_full"
  end

  def run
    folder_ids = Irm::Person.current.report_folders.collect{|i| i.id}
    @report = Irm::Report.multilingual.query_by_folders(folder_ids).with_report_type(I18n.locale).with_report_folder(I18n.locale).filter_by_folder_access(Irm::Person.current.id).find(params[:id])

    if "CUSTOM".eql?(@report.program_type)
      @report.attributes =  params[:irm_report]
    end

    @report.program_params = params[:program_params]||{}

    if params[:apply].present?
      @report.save
    end

    @filter_date_from=""
    @filter_date_to=""
    @filter_date_from = @report.filter_date_from.strftime("%Y-%m-%d") if @report.filter_date_from.present?
    @filter_date_to = @report.filter_date_to.strftime("%Y-%m-%d") if @report.filter_date_to.present?

    respond_to do |format|
        format.html { render(:action=>"show", :layout => "application_full") }
        format.xls  { send_data(export_report_data_to_excel(@report),:type => "text/plain", :filename=>"report_#{@report.code.downcase}_#{Time.now.strftime('%Y%m%d%H%M%S')}.xls") }
    end
  end


  def get_data
    folder_ids = []
    if params[:folder_id].present?
      folder_ids = [params[:folder_id]]
    else
      folder_ids = Irm::Person.current.report_folders.collect{|i| i.id}
    end
    reports_scope = Irm::Report.multilingual.query_by_folders(folder_ids).with_report_type(I18n.locale).with_report_folder(I18n.locale).with_report_trigger.filter_by_folder_access(Irm::Person.current.id).order("report_folder_id")

    respond_to do |format|
      format.json {
        reports_scope,count = paginate(reports_scope)
        reports_scope.each do |i|
          i[:editable_flag] = i.editable(i[:member_type],i[:access_type],Irm::Person.current.id)
        end
        render :json=>to_jsonp(reports_scope.to_grid_json([:name,
                                                           :editable_flag,
                                                           :report_trigger_id,
                                                           :code,:report_folder_name,
                                                           :report_type_name,
                                                           :description],count))}
      format.xls{
        send_data(data_to_xls(reports_scope,
                              [{:key=>:name,:label=>t(:label_irm_report_name)},
                               {:key=>:code,:label=>t(:label_irm_report_code)},
                               {:key=>:report_folder_name,:label=>t(:label_irm_report_folder)},
                               {:key=>:report_type_name,:label=>t(:label_irm_report_type)},
                               {:key=>:description,:label=>t(:label_irm_report_description)}]
                  ))
      }
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
    session[:irm_report][:report_group_columns_attributes].each{|key,value| value[:id]=nil}
    session[:irm_report][:report_criterions_attributes].each{|key,value| value[:id]=nil}
    @report = Irm::Report.new(session[:irm_report])

    respond_to do |format|
      if @report.valid?
         @report.sync_custom_report_params
         @report.create_columns_from_str
         @report.save
         session[:irm_report] = nil
        format.html { redirect_to({:action=>"show",:id=>@report.id}, :notice => t(:successfully_created)) }
        format.xml  { render :xml => @report, :status => :created, :location => @wf_rule }
      else
        format.html { render :action => "edit_custom" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new_program
    @report = Irm::Report.new(:program_type=>"PROGRAM")
    respond_to do |format|
      format.html { render :layout => "application_full"}# index.html.erb
    end
  end

  def create_program
    @report = Irm::Report.new(params[:irm_report])
    respond_to do |format|
      if @report.save
        format.html { redirect_to({:action=>"show",:id=>@report.id}, :notice => t(:successfully_created)) }
      else
        format.html { render :action => "new_program" }
      end
    end
  end

  def edit_program
    @report = Irm::Report.multilingual.find(params[:id])
    respond_to do |format|
      format.html { render :layout => "application_full"}# index.html.erb
    end
  end

  def update_program
    @report = Irm::Report.multilingual.find(params[:id])
    respond_to do |format|
      if @report.update_attributes(params[:irm_report])
        format.html { redirect_to({:action=>"show",:id=>@report.id}, :notice => t(:successfully_created)) }
      else
        format.html { render :action => "edit_program",:layout => "application_full" }
      end
    end
  end

  def edit_custom_program
    @report = Irm::Report.find(params[:id])
    @report.attributes = {:name=>nil,:description=>nil,:code=>nil}
    respond_to do |format|
      format.html { render :layout => "application_full"}# index.html.erb
    end
  end

  def update_custom_program
    @report = Irm::Report.new(params[:irm_report])
    respond_to do |format|
      if @report.save
        format.html { redirect_to({:action=>"show",:id=>@report.id}, :notice => t(:successfully_created)) }
      else
        format.html { render :action => "edit_custom_program", :layout => "application_full" }
      end
    end
  end

  private
  def export_report_data_to_excel(report)
    if "CUSTOM".eql?(report.program_type)
    if report.table_show_type.eql?("COMMON")
      return export_common(report)
    elsif report.table_show_type.eql?("GROUP")
      return export_group(report)
    elsif report.table_show_type.eql?("MATRIX")
      return export_group(report)
    end
    else
      return report.program_instance.to_xls(report.program_params)
    end

  end

  def export_common(report)
    columns = []
    report.report_header.each do |c|
       columns<<{:key=>c[0],:label=>c[1]}
    end
    datas = report.report_meta_data
    data_to_xls(datas,columns)
  end


  def export_group(report)
    # 报表表头信息
    report_headers = report.report_header
    #　报表分组列信息
    group_fields =  report.group_fields

    # 报表分组字段
    group_field_keys = group_fields.collect{|i| i[0]}

    # 报表分组后需要显示的列
    display_headers = report_headers.collect{|i| i unless group_field_keys.include?(i[0]) }.compact

    first_header_excel_format = {:pattern_bg_color => "builtin_yellow", :pattern_fg_color => "builtin_yellow", :pattern => 1,:weight=>:bold}
    second_header_excel_format = {:pattern_bg_color => "builtin_cyan", :pattern_fg_color => "builtin_yellow", :pattern => 1,:weight=>:bold}
    columns = []
    display_headers.each do |c|
       columns<<{:key=>c[0],:label=>c[1]}
    end

    export_data = []

    return export_data unless columns.any?

    meta_data = report.group_report_metadata
    level_one_label = report_headers.detect{|i| i[0].eql?(group_fields[0][0])}[1]
    level_two_label = ""
    if(group_fields.size>1)
      level_two_label = report_headers.detect{|i| i[0].eql?(group_fields[1][0])}[1]
    end
    meta_data.sort{|a,b| if a[0]&&b[0]; a[0]<=>b[0]; else; a[0]? 1:0; end}.map do |level_one_key,level_one_value|

      level_one_summary_amount = 0
      if(group_fields.size>1)
        level_one_value.values.each{|i| level_one_summary_amount+=i.size }
      else
        level_one_summary_amount = level_one_value.size
      end
      export_data << {:row_format=> first_header_excel_format,columns.first[:key]=>"#{level_one_label} : #{level_one_key}",columns.last[:key]=>"(#{level_one_summary_amount} #{t(:label_irm_report_records)})"}
      export_data << {:row_format=> first_header_excel_format}

      if(group_fields.size>1)
        level_one_value.sort{|a,b| if a[0]&&b[0]; a[0]<=>b[0]; else; a[0]? 1:0; end}.map do |level_two_key,level_two_value|
          level_two_summary_amount = level_two_value.size
          export_data << {:row_format=> second_header_excel_format,columns.first[:key]=>"       #{level_two_label} : #{level_two_key}",columns.last[:key]=>"(#{level_two_summary_amount} #{t(:label_irm_report_records)})"}
          export_data << {:row_format=> second_header_excel_format}
          level_two_value.each do |data|
            export_data << data
          end if report.show_detail?
        end
      else
        level_one_value.each do |data|
          export_data << data
        end  if report.show_detail?
      end
    end
    data_to_xls(export_data,columns)
  end
end
