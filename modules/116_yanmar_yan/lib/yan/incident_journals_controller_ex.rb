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
          #Icm::IncidentHistory.create({:request_id => @incident_request.id,
          #                             :journal_id=> "",
          #                             :property_key=> "update_workload_group",
          #                             :old_value => work[:support_group_id],
          #                             :new_value => work[:real_processing_time]})
          #暂不影响最后更新时间
          #ir.update_attribute(:last_response_date, Time.now)
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

      # POST /incident_journals
      # POST /incident_journals.xml
      def create
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