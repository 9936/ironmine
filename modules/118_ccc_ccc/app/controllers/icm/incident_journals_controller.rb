class Icm::IncidentJournalsController < ApplicationController

  before_filter :setup_up_incident_request
  before_filter :backup_incident_request ,:only=>[:create,:update_close,:update_permanent_close,:update_reopen,:update_pass,:update_status,:update_upgrade, :update_workload]

  def index
    redirect_to :action=>"new"
  end

  # GET /incident_journals/new
  # GET /incident_journals/new.xml
  def new
    @incident_journal = @incident_request.incident_journals.build()
    if params[:add_watcher]
      @incident_request.add_watcher(Irm::Person.current.id)
    end
    @incident_reply = Icm::IncidentReply.new()
    respond_to do |format|
      format.html { render :layout=>"application_right"}
      format.xml  { render :xml => @incident_journal }
      format.pdf {
        render :pdf => "[#{@incident_request.request_number}]#{@incident_request.title}",
               :print_media_type => true,
               :layout => 'layouts/pdf.html.erb',
               :encoding => 'utf-8'
      }
    end
  end

  def all_journals

  end


  # POST /incident_journals
  # POST /incident_journals.xml
  def create
    @incident_reply = Icm::IncidentReply.new(params[:icm_incident_reply])
    @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])
    # 设置回复类型
    # 1,客户回复
    # 2,服务台回复
    # 3,其他人员回复
    if Irm::Person.current.id.eql?(@incident_request.requested_by) || Irm::Person.current.id.eql?(@incident_request.support_person_id)
      @incident_journal.reply_type = "CUSTOMER_REPLY"
    # elsif Irm::Person.current.id.eql?(@incident_request.support_person_id)
    #   @incident_journal.reply_type = "SUPPORTER_REPLY"
    else
      @incident_journal.reply_type = "OTHER_REPLY"
    end
    #如果服务台人员手动修改状态，则使用手工修改的状态，如果状态为空则使用状态转移逻辑
    #unless @incident_reply.incident_status_id.present?
    if params[:new_incident_status_id] && !params[:new_incident_status_id].blank? && !params[:new_incident_status_id].eql?(@incident_request.incident_status_id)
      @incident_reply.incident_status_id = params[:new_incident_status_id]
    else
      @incident_reply.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id,@incident_journal.reply_type,@incident_request.external_system_id)
    end

    perform_create
    respond_to do |format|
      flag, now = validate_files(@incident_journal)
      if !flag
        if now.is_a?(Integer)
          flash[:notice] = I18n.t(:error_file_upload_limit, :m => Irm::SystemParametersManager.upload_file_limit.to_s, :n => now.to_s)
        else
          flash[:notice] = now
        end
        format.js do
          responds_to_parent do
            render :create_journal do |page|
            end
          end
        end
        format.html { render :action => "new", :layout=>"application_right"}
        format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
        format.json { render :json => @incident_journal.errors }
      elsif @incident_reply.valid? && @incident_journal.valid? && @incident_request.update_attributes(@incident_reply.attributes)
        process_change_attributes(@incident_reply.attributes.keys,@incident_request,@incident_request_bak,@incident_journal)
        process_files(@incident_journal)
        @incident_journal.create_elapse

        Icm::IncidentHistory.create({:request_id => @incident_journal.incident_request_id,
                                     :journal_id=> @incident_journal.id,
                                     :property_key=> "new_reply",
                                     :old_value=>"",
                                     :new_value=>@incident_journal.journal_number})

        format.js do
          @current_journals = Icm::IncidentJournal.list_all(@incident_request.id).includes(:incident_histories).where("#{Icm::IncidentJournal.table_name}.id = ?", @incident_journal.id)
          responds_to_parent do
            render :create_journal do |page|
            end
          end
        end
      else
        format.js do
          responds_to_parent do
            render :create do |page|
            end
          end
        end
      end
    end
  end

  def edit_status
    @incident_journal = @incident_request.incident_journals.build()
    respond_to do |format|
      format.html { render :layout => "application_full"}# new.html.erb
      format.xml  { render :xml => @incident_journal }
    end
  end


  def update_status

    sla_instance_id = params[:icm_incident_journal][:sla_instance_id]
    params[:icm_incident_journal].delete(:sla_instance_id)

    @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])

    @incident_request.attributes = params[:icm_incident_request]
    @incident_journal.reply_type = "STATUS"
    incident_request_bak = Icm::IncidentRequest.find(@incident_request.id)
    perform_create

    respond_to do |format|
      unless incident_request_bak.close?
        if @incident_journal.valid?&&@incident_request.save
          process_change_attributes1([:incident_status_id],@incident_request,@incident_request_bak,@incident_journal,sla_instance_id)
          process_files(@incident_journal)
          @incident_journal.create_elapse
          format.html { redirect_to({:action => "new"}) }
          format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
        else
          format.html { render :action => "edit_status", :layout => "application_full" }
          format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
        end
      else
        format.html { redirect_to({:action => "new"}) }
        format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
      end
    end
  end

  def edit_permanent_close
    @incident_journal = @incident_request.incident_journals.build()
    respond_to do |format|
      format.html { render :layout => "application_full"}# new.html.erb
      format.xml  { render :xml => @incident_journal }
    end
  end
  def update_permanent_close

    @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])

    @incident_request.attributes = params[:icm_incident_request]
    @incident_journal.reply_type = "PERMANENT_CLOSE"

    @incident_request.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id,@incident_journal.reply_type,@incident_request.external_system_id)

    perform_create
    respond_to do |format|
      if @incident_journal.valid?&&@incident_request.save
        process_change_attributes([:incident_status_id],@incident_request,@incident_request_bak,@incident_journal)
        process_files(@incident_journal)
        @incident_journal.create_elapse


        format.html { redirect_to({:action => "new"}) }
        format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
      else
        format.html { render :action => "edit_permanent_close", :layout => "application_full" }
        format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
      end
    end
  end
  def edit_reopen
    @incident_journal = @incident_request.incident_journals.build()
    respond_to do |format|
      format.html { render :layout => "application_right"}# new.html.erb
      format.xml  { render :xml => @incident_journal }
    end
  end
  def update_reopen

    @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])

    @incident_request.attributes = params[:icm_incident_request]
    @incident_journal.reply_type = "REOPEN"

    @incident_request.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id,@incident_journal.reply_type,@incident_request.external_system_id)

    perform_create
    respond_to do |format|
      if @incident_journal.valid?&&@incident_request.save
        process_change_attributes([:incident_status_id],@incident_request,@incident_request_bak,@incident_journal)
        process_files(@incident_journal)
        @incident_journal.create_elapse

        format.html { redirect_to({:action => "new"}) }
        format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
      else
        format.html { render :action => "edit_reopen", :layout => "application_right" }
        format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit_close
    @incident_journal = @incident_request.incident_journals.build()
    respond_to do |format|
      format.html { render :layout => "application_full"}# new.html.erb
      format.xml  { render :xml => @incident_journal }
    end
  end


  def update_close

    @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])

    @incident_request.attributes = params[:icm_incident_request]

    is_with_reply = @incident_journal.valid?
    if is_with_reply
      incident_journal_b = @incident_journal
      @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])
    end

    @incident_journal.reply_type = "CLOSE"

    @incident_request.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id,@incident_journal.reply_type,@incident_request.external_system_id)

    perform_create
    respond_to do |format|
      if @incident_journal.valid?&&@incident_request.save
        process_change_attributes([:incident_status_id,:close_reason_id],@incident_request,@incident_request_bak,@incident_journal)
        process_files(@incident_journal)
        @incident_journal.create_elapse
        Icm::IncidentHistory.create({:request_id => incident_journal_b.incident_request_id,
                                     :journal_id=> incident_journal_b.id,
                                     :property_key=> "new_reply",
                                     :old_value=>"",
                                     :new_value=>incident_journal_b.journal_number}) if is_with_reply

        #关闭事故单时，产生一个与之关联的投票任务
        Delayed::Job.enqueue(Icm::Jobs::IncidentRequestSurveyTaskJob.new(@incident_request.id))
        format.html { redirect_to({:action => "new"}) }
        format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
      else
        format.html { render :action => "edit_close", :layout => "application_full" }
        format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # 转交
  def edit_pass
    @incident_journal = @incident_request.incident_journals.build()
    @sla_instance_id = params[:sla_instance_id]
    respond_to do |format|
      format.html { render :action => "edit_pass",:layout => "application_full" }
      format.xml  { render :xml => @incident_journal }
    end
  end

  def update_pass
    sla_instance_id = params[:sla_instance_id]

    @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])
    @incident_journal.reply_type = "PASS"
    @incident_request.attributes = params[:icm_incident_request]
    perform_create(true)
    respond_to do |format|
      if @incident_journal.valid?&&@incident_request.support_group_id
        @incident_request.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id,@incident_journal.reply_type,@incident_request.external_system_id)
        support_person_id = @incident_request.support_person_id
        support_person_id = Icm::SupportGroup.find(@incident_request.support_group_id).assign_member_id unless support_person_id.present?
        @incident_request.support_person_id = support_person_id

        @incident_request.charge_person_id = support_person_id
        @incident_request.charge_group_id = @incident_request.support_group_id
        @incident_request.upgrade_person_id = support_person_id
        @incident_request.upgrade_group_id = @incident_request.upgrade_group_id
        @incident_request.save
        process_change_attributes([:incident_status_id,:support_group_id,:support_person_id,
                                   :charge_group_id,:charge_person_id,
                                   :upgrade_group_id,:upgrade_person_id],@incident_request,@incident_request_bak,@incident_journal)
        process_files(@incident_journal)
        @incident_journal.create_elapse
        # 转交后SLA重新计时
        sla_instance = Slm::SlaInstance.where(:id=>sla_instance_id)
        if sla_instance.length == 1
          updateData = {:current_duration => 0,
                        :start_at => Time.now,
                        :last_phase_start_date => Time.now}
          sla_instance.first.update_attributes(updateData)
        end
        # 转交后给支持人员发邮件提醒
        # 如果事故单状态处于受理中时则用新问题分配的邮件模板
        if @incident_request.incident_status_id.eql?("000K000922scMSu1Q8vthI")
          options = {:bo_id => @incident_request.id, :bo_code => "ICM_INCIDENT_REQUESTS", :action_id => "002i000B2jvcJDvCh6ck88", :action_type => "Irm::WfMailAlert"}
        else
          options = {:bo_id => @incident_request.id, :bo_code => "ICM_INCIDENT_REQUESTS", :action_id => "002i000B2jvGKXdQwvFVBI", :action_type => "Irm::WfMailAlert"}
        end
        Delayed::Job.enqueue(Irm::Jobs::ActionProcessJob.new(options))

        format.html { redirect_to({:action => "new"}) }
        format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
      else
        format.html { render :action => "edit_pass",:layout => "application_full" }
        format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
      end
    end
  end


  # 升级
  def edit_upgrade
    @incident_journal = @incident_request.incident_journals.build()
    respond_to do |format|
      format.html { render :action => "edit_upgrade",:layout => "application_full" }
      format.xml  { render :xml => @incident_journal }
    end
  end

  def update_upgrade
    @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])

    @incident_request.attributes = params[:icm_incident_request]

    current_support_group_id = Icm::SupportGroup.find(@incident_request.support_group_id).parent_group_id

    perform_create(true)
    respond_to do |format|
      if current_support_group_id.present?&&@incident_journal.valid?&&@incident_request.support_group_id
        @incident_journal.reply_type = "UPGRADE"
        @incident_request.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id,@incident_journal.reply_type,@incident_request.external_system_id)

        # 设置升级组
        @incident_request.upgrade_person_id = @incident_request_bak.support_person_id
        @incident_request.upgrade_group_id = @incident_request_bak.support_group_id

        # 设置支持组
        @incident_request.support_group_id = current_support_group_id

        support_person_id = @incident_request.support_person_id
        support_person_id = Icm::SupportGroup.find(@incident_request.support_group_id).assign_member_id unless support_person_id.present?

        @incident_request.support_person_id = support_person_id


        @incident_request.save

        process_change_attributes([:incident_status_id,:support_group_id,:support_person_id,
                                   :upgrade_group_id,:upgrade_person_id],@incident_request,@incident_request_bak,@incident_journal)
        process_files(@incident_journal)
        @incident_journal.create_elapse

        format.html { redirect_to({:action => "new"}) }
        format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
      else
        format.html { render :action => "edit_upgrade",:layout => "application_full" }
        format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
      end
    end

  end

  # 自动升级
  def direct_upgrade
    @incident_journal = @incident_request.incident_journals.build(:message_body=>"Upgrade")

    current_support_group_id = Icm::SupportGroup.find(@incident_request.support_group_id).parent_group_id

    perform_create(true)
    respond_to do |format|
      if current_support_group_id.present?&&@incident_journal.valid?&&@incident_request.support_group_id
        @incident_journal.reply_type = "UPGRADE"
        @incident_request.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id,@incident_journal.reply_type,@incident_request.external_system_id)

        # 设置升级组
        @incident_request.upgrade_person_id = @incident_request.support_person_id
        @incident_request.upgrade_group_id = @incident_request.upgrade_group_id

        # 设置支持组
        @incident_request.support_person_id = current_support_group_id

        support_person_id = @incident_request.support_person_id
        support_person_id = Icm::SupportGroup.find(@incident_request.support_group_id).assign_member_id unless support_person_id.present?

        @incident_request.support_person_id = support_person_id


        @incident_request.save

        process_change_attributes([:incident_status_id,:support_group_id,:support_person_id,
                                   :upgrade_group_id,:upgrade_person_id],@incident_request,@incident_request_bak,@incident_journal)
        process_files(@incident_journal)
        @incident_journal.create_elapse

        format.html { redirect_to({:action => "new"}) }
        format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
      end
    end

  end


  def get_entry_header_data
#    entry_headers_scope = Skm::EntryHeader.list_all.published.current_entry
#    entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.entry_title",params[:entry_title]) if params[:entry_title]
#    entry_headers,count = paginate(entry_headers_scope)

#全文检索
    if params[:entry_title].present?
      @skm_data = Sunspot.search Skm::EntryHeader do
        keywords params[:entry_title]
        with(:entry_status_code, "PUBLISHED")
        with(:history_flag, Irm::Constant::SYS_NO)
      end.results
    else
      @skm_data = {}
    end

    if  !params[:entry_title].nil? then
      @history = Skm::EntryOperateHistory.new({:operate_code=>"ICM_SEARCH",
                                               :incident_id=>@incident_request.id ,
                                               :search_key=>params[:entry_title],
                                               :result_count=>@skm_data.size})
      @history.save
    end

    respond_to do |format|
      format.js {render :apply_skm, :skm_data => @skm_data}
#      format.json  {render :json => to_jsonp(entry_headers.to_grid_json([:entry_status_code, :full_title, :entry_title, :keyword_tags,:doc_number,:version_number, :published_date_f], count)) }
    end
  end

  def apply_entry_header
    @entry_header = Skm::EntryHeader.find(params[:id])

    @history = Skm::EntryOperateHistory.new({:operate_code=>"ICM_APPLY",
                                             :incident_id=>@incident_request.id ,
                                             :entry_id=>params[:id],
                                             :version_number=>@entry_header.version_number})
    @history.save

    respond_to do |format|
      format.js
    end
  end

  def apply_entry_header_link
    @entry_header = Skm::EntryHeader.find(params[:id])

    @history = Skm::EntryOperateHistory.new({:operate_code=>"ICM_APPLY",
                                             :incident_id=>@incident_request.id ,
                                             :entry_id=>params[:id],
                                             :version_number=>@entry_header.version_number})
    @history.save

    respond_to do |format|
      format.js
    end
  end

  def edit
    @incident_journal = Icm::IncidentJournal.find(params[:id])
    respond_to do |format|
      format.html { render :layout => "application_full"}# new.html.erb
      format.xml  { render :xml => @incident_journal }
    end
  end

  def update
    @incident_journal = Icm::IncidentJournal.find(params[:id])
    source_number = @incident_journal.journal_number
    source_message_body = @incident_journal.message_body
    source_updated_at = @incident_journal.updated_at
    source_updated_by = @incident_journal.updated_by
    respond_to do |format|
      if @incident_journal.update_attributes(params[:icm_incident_journal])

        hi = Icm::IncidentHistory.create({:request_id => @incident_journal.incident_request_id,
                                          :journal_id=> @incident_journal.id,
                                          :property_key=> "update_journal",
                                          :old_value=> source_message_body,
                                          :new_value=> @incident_journal.message_body})

        Icm::JournalHistory.create({:incident_history_id => hi.id,
                                    :incident_journal_id => @incident_journal.id,
                                    :message_body => source_message_body,
                                    :source_updated_by => source_updated_by,
                                    :source_updated_at => source_updated_at})

        format.html { redirect_to({:action => "new"}) }
      else
        format.html { render "edit" }
      end
    end
  end

  #设置回复失效
  def delete
    incident_journal = Icm::IncidentJournal.find(params[:id])
    incident_journal.status_code = 'OFFLINE'
    if incident_journal.update_attributes({:status_code => "OFFLINE"})
      Icm::IncidentHistory.create({:request_id => incident_journal.incident_request_id,
                                   :journal_id=> incident_journal.id,
                                   :property_key=> "remove_journal",
                                   :old_value=> incident_journal.journal_number || incident_journal.id,
                                   :new_value=> ""})
    end
    @incident_request = incident_journal.incident_request
  end
  #还原删除的回复
  def recover
    incident_journal = Icm::IncidentJournal.find(params[:id])
    incident_journal.status_code = 'ENABLED'

    if incident_journal.save
      Icm::IncidentHistory.create({:request_id => incident_journal.incident_request_id,
                                   :journal_id=> incident_journal.id,
                                   :property_key=> "recover_journal",
                                   :old_value=> "",
                                   :new_value=> incident_journal.journal_number || incident_journal.id})
    end
    @incident_request = incident_journal.incident_request
  end

  def get_incident_history_data
    history_scope = Icm::IncidentHistory.
        select_all.
        without_some_property_key.
        with_value_label.
        with_created_by.
        only_with_request(params[:request_id]).
        order_by_created_at

    respond_to do |format|
      format.html {
        @datas,@count = paginate(history_scope)
        @datas.each do |t|
          meaning = t.meaning
          t[:new_value_label] = meaning[:new_meaning]
          t[:old_value_label] = meaning[:old_meaning]
        end
        render_html_data_table
      }
    end
  end

  private
  def check_incident_request_permission(scope)
    incident_request = scope.filter_system_ids(Irm::Person.current.system_ids).relate_person(Irm::Person.current.id).first
    if incident_request.present?
      return incident_request
    else
      redirect_to({:controller=>"icm/incident_requests",:action => "index"})
    end

  end


  def setup_up_incident_request
    @incident_request = Icm::IncidentRequest.list_all.query(params[:request_id])
    @incident_request = check_incident_request_permission(@incident_request)
  end

  def backup_incident_request
    @incident_request_bak = @incident_request.dup
  end

  def perform_create(pass=false)
    @incident_journal.replied_by=Irm::Person.current.id
    if limit_device?
      @incident_journal.message_body = "<pre>"+@incident_journal.message_body+"</pre>"
    end
    @incident_request.last_response_date = Time.now
    #if Irm::Person.current.id.eql?(@incident_request.requested_by)
    #  @incident_request.last_request_date = Time.now
    #end
    #if Irm::Person.current.id.eql?(@incident_request.support_person_id)
    #  @incident_request.last_response_date = Time.now unless pass
    #end
  end

  def process_change_attributes(attributes,new_value,old_value,ref_journal)
    attributes.each do |key|
      ovalue = old_value.send(key)
      nvalue = new_value.send(key)
      Icm::IncidentHistory.create({:request_id => ref_journal.incident_request_id,
                                   :journal_id=>ref_journal.id,
                                   :property_key=>key.to_s,
                                   :old_value=>ovalue,
                                   :new_value=>nvalue}) if !ovalue.eql?(nvalue)
    end
  end

  def process_change_attributes1(attributes,new_value,old_value,ref_journal,sla_instance_id)
    attributes.each do |key|
      ovalue = old_value.send(key)
      nvalue = new_value.send(key)

      if !ovalue.eql?(nvalue)
        if sla_instance_id
          # 事故单变为处理中或重新处理
          sla_instance = Slm::SlaInstance.where(:id=>sla_instance_id)
          # sla_instance_phase = Slm::SlaInstancePhase.where(:sla_instance_id=>sla_instance_id,:phase_type=>"START").order("start_at DESC").first
          # updateDatas = {:duration => 0,
          #               :start_at => Time.now}
          # if sla_instance_phase
          #   sla_instance_phase.update_attributes(updateDatas)
          # end

          if sla_instance.length == 1
            updateData = {:current_duration => 0,
                          :start_at => Time.now,
                          :last_phase_start_date => Time.now}
            sla_instance.first.update_attributes(updateData)
          end
        end
        # 如果事故单状态从受理中->处理中
        if ovalue.eql?("000K000922scMSu1Q8vthI") && nvalue.eql?("000K000C2hrdz1TO8kREaO")
          # 客户邮件
          options = {:bo_id => new_value.id, :bo_code => "ICM_INCIDENT_REQUESTS", :action_id => "002i000B2joAktx30siHFA", :action_type => "Irm::WfMailAlert"}
          Delayed::Job.enqueue(Irm::Jobs::ActionProcessJob.new(options))
          # 业务用户邮件
          options = {:bo_id => new_value.id, :bo_code => "ICM_INCIDENT_REQUESTS", :action_id => "002i000B2jsQV5MhXscJHc", :action_type => "Irm::WfMailAlert"}
          Delayed::Job.enqueue(Irm::Jobs::ActionProcessJob.new(options))
        end
        # 如果事故单状态从客户对应中->处理中
        if ovalue.eql?("000K000A0g8zPKXoIwOIhk") && nvalue.eql?("000K000C2hrdz1TO8kREaO")
          options = {:bo_id => new_value.id, :bo_code => "ICM_INCIDENT_REQUESTS", :action_id => "002i000B2joAktx33nmFxg", :action_type => "Irm::WfMailAlert"}
          Delayed::Job.enqueue(Irm::Jobs::ActionProcessJob.new(options))
        end
      end

      Icm::IncidentHistory.create({:request_id => ref_journal.incident_request_id,
                                   :journal_id=>ref_journal.id,
                                   :property_key=>key.to_s,
                                   :old_value=>ovalue,
                                   :new_value=>nvalue}) if !ovalue.eql?(nvalue)
    end
  end

  def process_files(ref_journal)
    @files = []
    params[:files].each do |key,value|
      file = Irm::AttachmentVersion.create({:source_id=>ref_journal.id,
                                            :source_type=>ref_journal.class.name,
                                            :data=>value[:file],
                                            :description=>value[:description]}) if(value[:file]&&!value[:file].blank?)
      if file
        Icm::IncidentHistory.create({:request_id => ref_journal.incident_request_id,
                                     :journal_id=> ref_journal.id,
                                     :property_key=> "attachment",
                                     :old_value=>file.name,
                                     :new_value=>""})
        @files << file
      end
    end if params[:files]
  end

  def validate_files(ref_journal)
    flash[:notice] = nil
    now = 0
    flag = true
    flag, now = Irm::AttachmentVersion.validates_repeat?(params[:files]) if params[:files]
    return false, now unless flag
    params[:files].each do |key, value|
      next unless value[:file] && value[:file].original_filename.present?
      flag, now = Irm::AttachmentVersion.validates?(value[:file], Irm::SystemParametersManager.upload_file_limit)
      return false, now unless flag
    end if params[:files]
    return true, now
  rescue Exception => e
    logger.debug(e.message)
    return false, now
  end
end
