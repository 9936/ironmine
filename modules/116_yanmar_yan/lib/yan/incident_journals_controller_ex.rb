module Yan::IncidentJournalsControllerEx
  def self.included(base)
    base.class_eval do

      def edit_additional_info
        @incident_request = Icm::IncidentRequest.find(params[:request_id])
      end

      def update_additional_info
        @incident_request = Icm::IncidentRequest.find(params[:request_id])
        @incident_request.update_attributes(params[:icm_incident_request])
      end

      def edit
        @incident_journal = Icm::IncidentJournal.find(params[:id])
        @workload = Icm::IncidentWorkload.
            joins("LEFT JOin #{Irm::Person.table_name} ip on ip.id = #{Icm::IncidentWorkload.table_name}.person_id").
            where("incident_journal_id = ?",params[:id]).
            select("#{Icm::IncidentWorkload.table_name}.*,ip.full_name,ip.login_name")
        respond_to do |format|
          format.html { render :layout => "application_full"}# new.html.erb
          format.xml  { render :xml => @incident_journal }
        end
      end

      def edit_workload
        @incident_request = Icm::IncidentRequest.find(params[:request_id])
        @incident_workloads = Icm::IncidentWorkload.
            joins(",#{Irm::Person.table_name} ip").
            joins(",icm_support_groups_vl sg").
            where("sg.language = ?", I18n.locale).
            where("#{Icm::IncidentWorkload.table_name}.group_id = sg.group_id").
            where("#{Icm::IncidentWorkload.table_name}.incident_request_id = ?", params[:request_id]).
            where("#{Icm::IncidentWorkload.table_name}.person_id = ?", Irm::Person.current.id).
            where("#{Icm::IncidentWorkload.table_name}.person_id = ip.id").
            select("#{Icm::IncidentWorkload.table_name}.*").
            select("ip.id supporter_id, ip.full_name supporter_name, ip.login_name login_name").
            select("sg.name support_group_name")

      end

      def update_workload
        @incident_request = Icm::IncidentRequest.find(params[:request_id])

        Icm::IncidentWorkload.where("incident_request_id = ?", params[:request_id]).where("person_id = ?", params[:person_id]).each do |t|
          t.destroy
        end

        params[:incident_workloads].each do |work|
          if work[:real_processing_time].blank? || work[:real_processing_time].to_f == 0 || work[:group_id].blank?
            next
          end
          Icm::IncidentWorkload.create(:incident_request_id => @incident_request.id,
                                       :real_processing_time => work[:real_processing_time],
                                       :group_id => work[:group_id],
                                       :person_id => work[:person_id])
          #暂不影响最后更新时间
        end if params[:incident_workloads]

      end

      def update_pass
        @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])
        @incident_journal.reply_type = "PASS"
        @incident_request.attributes = params[:icm_incident_request]

        #如果服务台人员手动修改状态，则使用手工修改的状态，如果状态为空则使用状态转移逻辑
        #unless @incident_reply.incident_status_id.present?
        if params[:new_incident_status_id] && !params[:new_incident_status_id].blank? && !params[:new_incident_status_id].eql?(@incident_request.incident_status_id)
          @incident_request.incident_status_id = params[:new_incident_status_id]
        else
          @incident_request.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id, @incident_journal.reply_type, @incident_request.external_system_id)
        end

        perform_create(true)
        respond_to do |format|
          if @incident_journal.valid?&&@incident_request.support_group_id
            #@incident_request.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id,@incident_journal.reply_type,@incident_request.external_system_id)
            support_person_id = @incident_request.support_person_id
            support_person_id = Icm::SupportGroup.find(@incident_request.support_group_id).assign_member_id unless support_person_id.present?
            @incident_request.support_person_id = support_person_id

            @incident_request.charge_person_id = support_person_id
            @incident_request.charge_group_id = @incident_request.support_group_id
            @incident_request.upgrade_person_id = support_person_id
            @incident_request.upgrade_group_id = @incident_request.upgrade_group_id
            @incident_request.save
            process_change_attributes([:incident_status_id, :support_group_id, :support_person_id,
                                       :charge_group_id, :charge_person_id,
                                       :upgrade_group_id, :upgrade_person_id], @incident_request, @incident_request_bak, @incident_journal)
            process_files(@incident_journal)
            @incident_journal.create_elapse
            format.html { redirect_to({:action => "new"}) }
            format.xml { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
          else
            format.html { render :action => "edit_pass", :layout => "application_full" }
            format.xml { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
          end
        end
      end

      def update
        @incident_journal = Icm::IncidentJournal.find(params[:id])
        source_number = @incident_journal.journal_number
        source_message_body = @incident_journal.message_body
        source_updated_at = @incident_journal.updated_at
        source_updated_by = @incident_journal.updated_by
        record = Icm::IncidentWorkload.where("incident_journal_id = ?",params[:id]).first
        if record.present?
          start_time = record.start_time
          end_time = record.end_time
          time = ((end_time - start_time)/60).to_i
          errornotice = nil
          params[:incident_workloads].each do |work|
            if work[:real_processing_time].to_i > time
              errornotice = "processing time is larger than #{time}"
              break
            end
          end
        end
        if errornotice.present?
          respond_to do |format|
            flash[:notice] = errornotice
            @workload = Icm::IncidentWorkload.
                joins("LEFT JOin #{Irm::Person.table_name} ip on ip.id = #{Icm::IncidentWorkload.table_name}.person_id").
                where("incident_journal_id = ?",params[:id]).
                select("#{Icm::IncidentWorkload.table_name}.*,ip.full_name,ip.login_name")
            format.html { render "edit", :layout => "application_full"}
          end
        else
        respond_to do |format|

          if @incident_journal.update_attributes(params[:icm_incident_journal])
            record = Icm::IncidentWorkload.where("incident_journal_id = ?",params[:id]).first
            if record.present?
            start_time = record.start_time
            end_time = record.end_time
            Icm::IncidentWorkload.where("incident_journal_id = ?",params[:id]).each do |t|
              t.destroy
            end
            params[:incident_workloads].each do |work|
              if work[:real_processing_time].blank? || work[:real_processing_time].to_f == 0 || work[:person_id].blank?
                next
              end
              Icm::IncidentWorkload.create(:incident_request_id => params[:request_id],
                                           :real_processing_time => work[:real_processing_time],
                                           :incident_journal_id => params[:id],
                                           :start_time => start_time,
                                           :end_time => end_time,
                                           :person_type => work[:person_type],
                                           :person_id => work[:person_id])
              end
            end

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
            format.html { render "edit", :layout => "application_full"}
          end
        end
        end
      end


      # POST /incident_journals
      # POST /incident_journals.xml
      def create
        start_time = nil
        status_time_record = Icm::IncidentHistory.where("request_id = ? AND property_key = 'support_person_id' ",params[:request_id]).order("created_at DESC").first
        supporter_time_record = Icm::IncidentHistory.where("request_id = ? AND (property_key = 'new_reply' or property_key = 'incident_status_id') ",params[:request_id]).order("created_at DESC").first

        if supporter_time_record.present? && status_time_record.present?
          if supporter_time_record.created_at > status_time_record.created_at
            start_time=supporter_time_record.created_at
          else
            start_time=status_time_record.created_at
          end
        end
        if supporter_time_record.present? && !status_time_record.present?
          start_time=supporter_time_record.created_at
        end
        if !supporter_time_record.present? && status_time_record.present?
          start_time=status_time_record.created_at
        end
        end_time = Time.now
        workload_status_id = @incident_request.incident_status_id
        time = ((Time.now - start_time)/60).to_i
        if params[:incident_workloads].present?
          errornotice = nil
          params[:incident_workloads].each do |work|
            if work[:real_processing_time].to_i > time
              errornotice = "processing time is larger than #{time}"
              break
            end
          end
        end
        if (!(@incident_request.watcher?(Irm::Person.current.id)&&allow_to_function?(:reply_incident_request)&&!@incident_request.close?&&!@incident_request.permanent_close? && @incident_request.status_code.eql?(Irm::Constant::ENABLED)))
          @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])
          respond_to do |format|
            format.js do
              responds_to_parent do
                render :create do |page|
                end
              end
            end
          end
        elsif errornotice.present?
            respond_to do |format|
              format.js do
                flash[:notice] = errornotice
                responds_to_parent do
                  render :notice do |page|
                  end
                end
              end
            end
        else

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
          #unless @incident_reply.incident_status_id.present?
          if params[:new_incident_status_id] && !params[:new_incident_status_id].blank? && !params[:new_incident_status_id].eql?(@incident_request.incident_status_id)
            @incident_reply.incident_status_id = params[:new_incident_status_id]
          else
            @incident_reply.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id, @incident_journal.reply_type, @incident_request.external_system_id)
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
              format.html { render :action => "new", :layout => "application_right" }
              format.xml { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
              format.json { render :json => @incident_journal.errors }
            elsif @incident_reply.valid? && @incident_journal.valid? && @incident_request.update_attributes(@incident_reply.attributes)
                process_change_attributes(@incident_reply.attributes.keys, @incident_request, @incident_request_bak, @incident_journal)
                process_files(@incident_journal, (params[:if_private_reply] && params[:if_private_reply].eql?('Y')) ? 'Y' : 'N')
                @incident_journal.create_elapse

                if params[:incident_workloads].present?
                  params[:incident_workloads].each do |work|
                    Icm::IncidentWorkload.create({:incident_request_id => @incident_journal.incident_request_id,
                                                  :incident_journal_id => @incident_journal.id,
                                                  :person_id => @incident_journal.replied_by,
                                                  :real_processing_time => work[:real_processing_time],
                                                  :person_type => work[:person_type],
                                                  :start_time => start_time,
                                                  :end_time => end_time,
                                                  :incident_status_id => workload_status_id,})
                  end
                end

                Icm::IncidentHistory.create({:request_id => @incident_journal.incident_request_id,
                                             :journal_id => @incident_journal.id,
                                             :property_key => "new_reply",
                                             :old_value => "",
                                             :new_value => @incident_journal.journal_number})

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

      end

      def process_files(ref_journal, private_flag = 'N')
        @files = []
        params[:files].each do |key, value|
          file = Irm::AttachmentVersion.create({:source_id => ref_journal.id,
                                                :source_type => ref_journal.class.name,
                                                :private_flag => private_flag,
                                                :data => value[:file],
                                                :description => value[:description]}) if (value[:file]&&!value[:file].blank?)
          if file
            Icm::IncidentHistory.create({:request_id => ref_journal.incident_request_id,
                                         :journal_id => ref_journal.id,
                                         :property_key => "attachment",
                                         :old_value => file.name,
                                         :new_value => ""})
            @files << file
          end
        end if params[:files]
      end
    end
  end
end