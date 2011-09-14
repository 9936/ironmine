class Icm::IncidentJournalsController < ApplicationController

  before_filter :setup_up_incident_request
  before_filter :backup_incident_request ,:only=>[:create,:update_close,:update_pass,:update_status,:update_upgrade]

  def index
   redirect_to :action=>"new"
  end

  # GET /incident_journals/new
  # GET /incident_journals/new.xml
  def new
    @incident_journal = @incident_request.incident_journals.build()

    @incident_reply = Icm::IncidentReply.new()
    respond_to do |format|
      format.html { render :layout=>"application_right"}
      format.xml  { render :xml => @incident_journal }
    end
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
    if Irm::Person.current.id.eql?(@incident_request.requested_by)
      @incident_journal.reply_type = "CUSTOMER_REPLY"
    elsif Irm::Person.current.id.eql?(@incident_request.support_person_id)
      @incident_journal.reply_type = "SUPPORTER_REPLY"
    else
      @incident_journal.reply_type = "OTHER_REPLY"
    end
    #如果服务台人员手动修改状态，则使用手工修改的状态，如果状态为空则使用状态转移逻辑
    unless @incident_reply.incident_status_id.present?
      @incident_reply.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id,@incident_journal.reply_type)
    end

    perform_create
    respond_to do |format|
      flag, now = validate_files(@incident_journal)
      if !flag
        flash[:notice] = I18n.t(:error_file_upload_limit, :m => Irm::SystemParametersManager.upload_file_limit.to_s, :n => now.to_s)
        format.html { render :action => "new", :layout=>"application_right"}
        format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
      elsif @incident_reply.valid? && @incident_request.update_attributes(@incident_reply.attributes)
        process_change_attributes(@incident_reply.attributes.keys,@incident_request,@incident_request_bak,@incident_journal)
        process_files(@incident_journal)
        format.html { redirect_to({:action => "new"}) }
        format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
      else
        format.html { render :action => "new", :layout=>"application_right"}
        format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
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

    @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])

    @incident_request.attributes = params[:icm_incident_request]
    # 设置回复类开
    # 1,服务台回复
    # 2,客户回复
    if Irm::Person.current.profile&& Irm::Person.current.profile.user_license.eql?("REQUESTER")
      @incident_journal.reply_type = "CUSTOMER_REPLY"
    else
      @incident_journal.reply_type = "SUPPORTER_REPLY"
    end

    perform_create
    respond_to do |format|
      if @incident_journal.valid?&&@incident_request.save
        process_change_attributes([:incident_status_id],@incident_request,@incident_request_bak,@incident_journal)
        process_files(@incident_journal)

        format.html { redirect_to({:action => "new"}) }
        format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
      else
        format.html { render :action => "edit_status", :layout => "application_full" }
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
    @incident_journal.reply_type = "CLOSE"

    @incident_request.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id,@incident_journal.reply_type)

    perform_create
    respond_to do |format|
      if @incident_journal.valid?&&@incident_request.save
        process_change_attributes([:incident_status_id,:close_reason_id],@incident_request,@incident_request_bak,@incident_journal)
        process_files(@incident_journal)

        #关闭事故单时，产生一个与之关联的投票任务
        Delayed::Job.enqueue(Irm::Jobs::IcmIncidentRequestSurveyTaskJob.new(@incident_request.id))
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
    respond_to do |format|
      format.html { render :action => "edit_pass",:layout => "application_full" }
      format.xml  { render :xml => @incident_journal }
    end
  end

  def update_pass
    @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])

    @incident_request.attributes = params[:icm_incident_request]

    perform_create(true)
    respond_to do |format|
      if @incident_journal.valid?&&@incident_request.support_group_id
        @incident_journal.reply_type = "PASS"
        @incident_request.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id,@incident_journal.reply_type)
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
        @incident_request.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id,@incident_journal.reply_type)

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
          @incident_request.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id,@incident_journal.reply_type)

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
          format.html { redirect_to({:action => "new"}) }
          format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
        end
      end

  end


  def get_entry_header_data
    entry_headers_scope = Skm::EntryHeader.list_all.published.current_entry
    entry_headers_scope = entry_headers_scope.match_value("#{Skm::EntryHeader.table_name}.entry_title",params[:entry_title]) if params[:entry_title]
    entry_headers,count = paginate(entry_headers_scope)

    if  !params[:entry_title].nil? then
      @history = Skm::EntryOperateHistory.new({:operate_code=>"ICM_SEARCH",
                                               :incident_id=>@incident_request.id ,
                                               :search_key=>params[:entry_title],
                                               :result_count=>count})
      @history.save
    end

    respond_to do |format|
      format.json  {render :json => to_jsonp(entry_headers.to_grid_json([:entry_status_code, :full_title, :entry_title, :keyword_tags,:doc_number,:version_number, :published_date_f], count)) }
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

  private
  def setup_up_incident_request
    @incident_request = Icm::IncidentRequest.list_all.with_incident_status(I18n.locale).find(params[:request_id])
  end

  def backup_incident_request
    @incident_request_bak = @incident_request.dup  
  end

  def perform_create(pass=false)
    @incident_journal.replied_by=Irm::Person.current.id
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
        Icm::IncidentHistory.create({:journal_id=>ref_journal.id,
                                     :property_key=>key.to_s,
                                     :old_value=>ovalue,
                                     :new_value=>nvalue}) if !ovalue.eql?(nvalue)
    end
  end

  def process_files(ref_journal)
    @files = []
    params[:files].each do |key,value|
      @files << Irm::AttachmentVersion.create({:source_id=>ref_journal.id,
                                               :source_type=>ref_journal.class.name,
                                               :data=>value[:file],
                                               :description=>value[:description]}) if(value[:file]&&!value[:file].blank?)
    end if params[:files]
  end

  def validate_files(ref_journal)
    now = 0
    params[:files].each do |key,value|
      flag, now = Irm::AttachmentVersion.validates?(value[:file], Irm::SystemParametersManager.upload_file_limit)
      return false, now unless flag
    end if params[:files]
    return true, now
  rescue
    return false, now
  end
end
