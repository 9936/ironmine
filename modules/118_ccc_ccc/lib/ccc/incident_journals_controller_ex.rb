
module Ccc::IncidentJournalsControllerEx

  def self.included(base)
    base.class_eval do
      def new
        @incident_request = Icm::IncidentRequest.list_all.find(params[:request_id])

        @incident_journal = @incident_request.incident_journals.build()

        @supporters = Icm::IncidentWorkload.joins(",#{Irm::Person.table_name} ip").
                        select("DISTINCT ip.id supporter_id, ip.full_name supporter_name, ip.login_name login_name, #{Icm::IncidentWorkload.table_name}.real_processing_time real_processing_time").
                        where("#{Icm::IncidentWorkload.table_name}.incident_request_id = ? AND #{Icm::IncidentWorkload.table_name}.person_id = ip.id", @incident_request.id).
                        where("LENGTH(#{Icm::IncidentWorkload.table_name}.real_processing_time) > 0").
                        where("ip.assignment_availability_flag = ?", Irm::Constant::SYS_YES)

        @incident_reply = Icm::IncidentReply.new()
        @external_system = Irm::ExternalSystem.find(@incident_request.external_system_id)
        @show_external_system = Irm::ExternalSystem.list_all.find(@incident_request.external_system_id)
        @object_project_manager = nil
        project_manager = @show_external_system[:project_manager]
        if project_manager.present?
          login_name = project_manager.split("(")[1].split(")")[0]
          @object_project_manager = Irm::Person.where("login_name = ?", login_name).first()
        end
        @show_external_system = solve_people_date_message(@incident_request,@show_external_system)
        # @organization = Irm::Organization.list_all.where(:organization_no=>@show_external_system.organization_no).first()
        @organization = Irm::Organization.list_all.find(Irm::Person.find(@incident_request.requested_by).organization_id)

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

      def create
        sla_instance_id = params[:icm_incident_journal][:sla_instance]
        params[:icm_incident_journal].delete(:sla_instance)

        @incident_reply = Icm::IncidentReply.new(params[:icm_incident_reply])
        @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])
        # 设置回复类型
        # 1,客户回复
        # 2,服务台回复
        # 3,其他人员回复
        # 4,内部回复
        if params[:inner_reply_flag].eql?("Y")
          @incident_journal.reply_type = "INNER_REPLY"
        else
          if Irm::Person.current.id.eql?(@incident_request.requested_by)
            @incident_journal.reply_type = "CUSTOMER_REPLY"
          elsif Irm::Person.current.id.eql?(@incident_request.support_person_id)
            @incident_journal.reply_type = "SUPPORTER_REPLY"
          else
            @incident_journal.reply_type = "OTHER_REPLY"
          end
        end
        #如果服务台人员手动修改状态，则使用手工修改的状态，如果状态为空则使用状态转移逻辑
        unless (params[:keep_next_status] && params[:keep_next_status].eql?("Y")) || @incident_reply.incident_status_id.present?
          @incident_reply.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id,@incident_journal.reply_type,@incident_request.external_system_id)
        end

        perform_create

        if params[:workload]
          @incident_journal.workload = params[:workload]
          @incident_journal.workload_type = params[:workload_type]
        end
        respond_to do |format|
          flag, now = validate_files(@incident_journal)
          if !flag
            flash[:notice] = I18n.t(:error_file_upload_limit, :m => Irm::SystemParametersManager.upload_file_limit.to_s, :n => now.to_s)
            format.js do
              responds_to_parent do
                render :create_journal do |page|
                end
              end
            end
            format.html { render :action => "new", :layout=>"application_right"}
            format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
          elsif @incident_reply.valid? && @incident_journal.valid? && @incident_request.update_attributes(@incident_reply.attributes)
            process_change_attributes(@incident_reply.attributes.keys,@incident_request,@incident_request_bak,@incident_journal)
            process_files(@incident_journal)
            es = Irm::ExternalSystem.find(@incident_request.external_system_id)
            @incident_journal.create_elapse
            @incident_request.save
            if @incident_journal.id.present? && es.strict_workload.eql?('Y') && @incident_journal.workload.present? && !@incident_journal.reply_type.eql?("CUSTOMER_REPLY") && !@incident_journal.workload.eql?("0")
              Icm::IncidentWorkload.create({:incident_request_id => @incident_journal.incident_request_id,
                                            :incident_journal_id => @incident_journal.id,
                                            :real_processing_time => @incident_journal.workload,
                                            :person_id => @incident_journal.replied_by,
                                            :workload_type => params[:workload_type]})
            end
            Icm::IncidentHistory.create({:request_id => @incident_journal.incident_request_id,
                                         :journal_id=> @incident_journal.id,
                                         :property_key=> "new_reply",
                                         :old_value=>"",
                                         :new_value=>@incident_journal.journal_number})

            # 此处评论创建成功,如果回复的人是顾问,且事故单状态不处于提交方案和客户对应时需要重新计时
            if (Irm::Person.find(@incident_journal.replied_by).profile.user_license.eql?("SUPPORTER"))
              if !@incident_request.incident_status_id.eql?("000K000A0g8zPKXoIwOIhk") && !@incident_request.incident_status_id.eql?("000K000A0g9LO0pOKPsZ1s")
                if sla_instance_id.present?
                  sla_instance = Slm::SlaInstance.find(sla_instance_id)
                  sa = Slm::ServiceAgreement.find(sla_instance.service_agreement_id)
                  Slm::SlaInstance.start(sa,{:bo_type => "Icm::IncidentRequest", :bo_id => @incident_request.id, :service_agreement_id => sa.id})
                  sla_instance.destroy
                end
              end
            end
            format.js do
              @current_journals = Icm::IncidentJournal.list_all(@incident_request.id).includes(:incident_histories).where("#{Icm::IncidentJournal.table_name}.id = ?", @incident_journal.id)
              responds_to_parent do
                render :create_journal do |page|
                end
              end
            end
            # format.html { redirect_to({:action => "new"}) }
            format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
          else
            format.js do
              responds_to_parent do
                render :create do |page|
                end
              end
            end
            format.html { render :action => "new", :layout=>"application_right"}
            format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
          end

        end
      end

      def edit_workload
        @incident_journal = @incident_request.incident_journals.build()
        @external_system = Irm::ExternalSystem.find(@incident_request.external_system_id)

        @supporters = Icm::IncidentWorkload.joins(",#{Irm::Person.table_name} ip").joins(",#{Irm::LookupValue.view_name} lv").
                    where("lv.language = ?", I18n.locale).where("lv.lookup_type = ?", "WORKLOAD_TYPE").
                    where("lv.lookup_code = #{Icm::IncidentWorkload.table_name}.workload_type").
                    select("DISTINCT ip.id supporter_id, ip.full_name supporter_name, ip.login_name login_name, #{Icm::IncidentWorkload.table_name}.real_processing_time real_processing_time, #{Icm::IncidentWorkload.table_name}.workload_type workload_type, lv.meaning workload_type_label").
                    where("#{Icm::IncidentWorkload.table_name}.incident_request_id = ? AND #{Icm::IncidentWorkload.table_name}.person_id = ip.id", @incident_request.id).
                    where("LENGTH(#{Icm::IncidentWorkload.table_name}.real_processing_time) > 0")

        @supporters = Icm::IncidentJournal.where("1=1").
                joins(",#{Irm::Person.table_name} ip").
                select("DISTINCT ip.id supporter_id, ip.full_name supporter_name, ip.login_name login_name, (SELECT iw.real_processing_time FROM #{Icm::IncidentWorkload.table_name} iw WHERE iw.incident_request_id = #{Icm::IncidentJournal.table_name}.incident_request_id AND iw.person_id = ip.id) real_processing_time").
                where("ip.id = #{Icm::IncidentJournal.table_name}.replied_by").
                where("ip.assignment_availability_flag = ?", Irm::Constant::SYS_YES).
                where("#{Icm::IncidentJournal.table_name}.incident_request_id = ?", @incident_request.id) unless @supporters.any?

        respond_to do |format|
          format.html { render :layout => "application_full"}# new.html.erb
          format.xml  { render :xml => @incident_journal }
        end
      end

      def register_workload
        ir = Icm::IncidentRequest.find(@incident_request.id)
        es = Irm::ExternalSystem.find(ir.external_system_id)
        if es.strict_workload.eql?('Y')
          Icm::IncidentWorkload.create({:incident_request_id => ir.id,
                                        :incident_journal_id => nil,
                                        :real_processing_time => params[:workload],
                                        :person_id => Irm::Person.current.id,
                                        :workload_type => params[:workload_type]})
        end
        render json: {:result=>"ok"}
      end

      def update_workload
        ir = Icm::IncidentRequest.find(@incident_request.id)
        @incident_request.attributes = params[:icm_incident_request]
        # @external_system = Irm::ExternalSystem.find(@incident_request.external_system_id)

        respond_to do |format|
          if ir.update_attributes(params[:icm_incident_request])

            # Icm::IncidentWorkload.where("incident_request_id = ?", ir.id).each do |t|
            #   t.destroy
            # end
            # params[:incident_workloads].each do |work|
            #   if work[:real_processing_time].blank? || work[:real_processing_time].to_f == 0 || work[:person_id].blank?
            #     next
            #   end
              # Icm::IncidentWorkload.create(:incident_request_id => @incident_request.id,
              #                              :real_processing_time => work[:real_processing_time],
              #                              :workload_type => work[:workload_type],
              #                              :person_id => work[:person_id])
              Icm::IncidentHistory.create({:request_id => @incident_request.id,
                                           :journal_id=> "",
                                           :property_key=> "update_people_date",
                                           :old_value => Irm::Person.current.id,
                                           :new_value => nil})
              ir.update_attribute(:last_response_date, Time.now)
            # end if params[:incident_workloads]


            # if params[:next_status]
            #   incident_request_bak = Icm::IncidentRequest.find(@incident_request.id)
            #   @incident_request.update_attribute(:incident_status_id,params[:next_status])
            #   @incident_journal = @incident_request.incident_journals.build()
            #   @incident_journal.reply_type = "STATUS"
            #   @incident_journal.replied_by=Irm::Person.current.id
            #   puts @incident_journal.inspect
            #   @incident_journal.save
            #   ovalue = incident_request_bak.incident_status_id
            #   nvalue = params[:next_status]
            #   Icm::IncidentHistory.create({:request_id => @incident_request.id,
            #                                :journal_id=> @incident_journal.id,
            #                                :property_key=>"incident_status_id",
            #                                :old_value=>ovalue,
            #                                :new_value=>nvalue}) if !ovalue.eql?(nvalue)
            # end

            format.html { redirect_to({:action => "new"}) }
            format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
          end
        end
      end

      def update_people_date
        @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])
        @incident_request = Icm::IncidentRequest.list_all.query(params[:id])
        @incident_request = check_incident_request_permission(@incident_request)
        respond_to do |format|
          if @incident_request.update_attributes(params[:icm_incident_request])
            format.html { redirect_to({:action => "new"}) }
            format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
          # else
          #   if @incident_request.errors[:attribute3]
          #     @incident_journal.errors.add(:workload,@incident_request.errors[:attribute3])
          #   end
          #   if @incident_request.errors[:attribute4]
          #     @incident_journal.errors.add(:reply_type,@incident_request.errors[:attribute4])
          #   end
          #   puts "1111111111111"
          #   puts @incident_journal.errors.inspect
          #   format.html { render :action => "new", :layout=>"application_right"}
          #   # format.xml  { render :xml => @incident_request.errors, :status => :unprocessable_entity ,:location => @incident_journal}
          #   # format.html { redirect_to({:action => "new"}) }
          #   format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
          end
        end
      end

      def remove_journal
        journal = Icm::IncidentJournal.find(params[:journal_id])
        if journal
          journal.update_attribute(:status_code, :OFFLINE)
          Icm::IncidentHistory.create({:request_id => journal.incident_request_id,
                                       :journal_id=> journal.id,
                                       :property_key=> "remove_journal",
                                       :old_value=>"",
                                       :new_value=>journal.journal_number})
          journal.count_reply
        end
        respond_to do |format|
            format.html { redirect_to({:action => "new", :request_id => params[:request_id]}) }
        end
      end

      def grade_of_satisfy
        if Ccc::SatisRateOfConsultant.where(:incident_request_id=>params[:request_id]).length == 0
          Ccc::SatisRateOfConsultant.create({:supporter_id => params[:supporter_id],
                                             :incident_request_id => params[:request_id],
                                             :grade_type => params[:grade_type],
                                             :bad_reason => params[:bad_reason]
                                           })
        end
        render json: {:result=>"ok"}
      end

      def get_incident_history_data
        history_scope = Icm::IncidentHistory.
            select_all.
            without_some_property_key.
            with_value_label.
            with_created_by.
            only_with_request(params[:request_id]).
            order_by_created_at.where("property_key != 'priority_id'")

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

      def edit_close
        @incident_journal = @incident_request.incident_journals.build()

        @supporters = Icm::IncidentWorkload.joins(",#{Irm::Person.table_name} ip").joins(",#{Irm::LookupValue.view_name} lv").
                    where("lv.language = ?", I18n.locale).where("lv.lookup_type = ?", "WORKLOAD_TYPE").
                    where("lv.lookup_code = #{Icm::IncidentWorkload.table_name}.workload_type").
                    select("DISTINCT ip.id supporter_id, ip.full_name supporter_name, ip.login_name login_name, #{Icm::IncidentWorkload.table_name}.real_processing_time real_processing_time, #{Icm::IncidentWorkload.table_name}.workload_type workload_type, lv.meaning workload_type_label").
                    where("#{Icm::IncidentWorkload.table_name}.incident_request_id = ? AND #{Icm::IncidentWorkload.table_name}.person_id = ip.id", @incident_request.id).
                    where("LENGTH(#{Icm::IncidentWorkload.table_name}.real_processing_time) > 0")

        @supporters = Icm::IncidentJournal.where("1=1").
                joins(",#{Irm::Person.table_name} ip").
                select("DISTINCT ip.id supporter_id, ip.full_name supporter_name, ip.login_name login_name, (SELECT iw.real_processing_time FROM #{Icm::IncidentWorkload.table_name} iw WHERE iw.incident_request_id = #{Icm::IncidentJournal.table_name}.incident_request_id AND iw.person_id = ip.id) real_processing_time").
                where("ip.id = #{Icm::IncidentJournal.table_name}.replied_by").
                where("ip.assignment_availability_flag = ?", Irm::Constant::SYS_YES).
                where("#{Icm::IncidentJournal.table_name}.incident_request_id = ?", @incident_request.id) unless @supporters.any?

        respond_to do |format|
          format.html { render :layout => "application_right"}# new.html.erb
          format.xml  { render :xml => @incident_journal }
        end
      end

      def update_close
        @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])
        @incident_request.attributes = params[:icm_incident_request]
        @incident_journal.reply_type = "OTHER_REPLY"

        is_with_reply = @incident_journal.valid?
        if is_with_reply
          incident_journal_b = @incident_journal
          @incident_journal = @incident_request.incident_journals.build(params[:icm_incident_journal])
        end
        @incident_journal.reply_type = "CLOSE"

        @incident_request.incident_status_id = Icm::IncidentStatus.transform(@incident_request.incident_status_id,@incident_journal.reply_type,@incident_request.external_system_id)
        perform_create
        respond_to do |format|
          if @incident_request.save
            # Icm::IncidentWorkload.where("incident_request_id = ?", @incident_request.id).each do |t|
            #   t.destroy
            # end
            # params[:incident_workloads].each do |work|
            #   if work[:real_processing_time].blank? || work[:real_processing_time].to_f == 0 || work[:person_id].blank?
            #     next
            #   end
            #   Icm::IncidentWorkload.create(:incident_request_id => @incident_request.id,
            #                                :real_processing_time => work[:real_processing_time],
            #                                :workload_type => work[:workload_type],
            #                                :person_id => work[:person_id])
            # end if params[:incident_workloads]

            incident_journal_b.create_elapse if is_with_reply
            Icm::IncidentHistory.create({:request_id => incident_journal_b.incident_request_id,
                                         :journal_id=> incident_journal_b.id,
                                         :property_key=> "new_reply",
                                         :old_value=>"",
                                         :new_value=>incident_journal_b.journal_number}) if is_with_reply

            process_change_attributes([:incident_status_id,:close_reason_id],@incident_request,@incident_request_bak,@incident_journal)
            #process_files(@incident_journal)
            @incident_journal.create_elapse
            #关闭事故单时，产生一个与之关联的投票任务
            # Delayed::Job.enqueue(Irm::Jobs::IcmIncidentRequestSurveyTaskJob.new(@incident_request.id))
            format.html { redirect_to({:action => "new"}) }
            format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
          else
            format.html { render :action => "edit_close", :layout => "application_full" }
            format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
          end
        end
      end

      def update
        @incident_journal = Icm::IncidentJournal.find(params[:id])
        source_number = @incident_journal.journal_number
        source_message_body = @incident_journal.message_body
        source_updated_at = @incident_journal.updated_at
        source_updated_by = @incident_journal.updated_by
        respond_to do |format|
          if @incident_journal.update_attributes(params[:icm_incident_journal]) &&
              @incident_journal.update_attribute(:journal_number, @incident_journal.generate_journal_number)
            wl = Icm::IncidentWorkload.where("incident_journal_id = ?", params[:id])
            if wl.any?
              wl = wl.first
              wl.update_attribute(:real_processing_time, @incident_journal.workload)
            else
              Icm::IncidentWorkload.create({:incident_request_id => @incident_journal.incident_request_id,
                                            :incident_journal_id => @incident_journal.id,
                                            :real_processing_time => @incident_journal.workload,
                                            :person_id => @incident_journal.replied_by,
                                            :workload_type => 'REMOTE'})
            end
            hi = Icm::IncidentHistory.create({:request_id => @incident_journal.incident_request_id,
                                         :journal_id=> @incident_journal.id,
                                         :property_key=> "update_journal",
                                         :old_value=>source_number,
                                         :new_value=>@incident_journal.journal_number})

            Icm::JournalHistory.create({:incident_history_id => hi.id,
                                     :source_journal_number => source_number,
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

      private

      def solve_people_date_message(incident,external_system) # 处理人天信息的方法
        # 2015-12-22->2015-12-31:123;312
        incident_created_at = incident.created_at.strftime("%F")
        external_system_people_date = external_system.people_date_message
        if external_system_people_date.present? && !external_system_people_date.eql?("->:;")
          external_system_people_date.split("||").each do |espd|
            date = espd.split(":")[0]
            date_message = espd.split(":")[1]
            if date.split("->")[0] <= incident_created_at && date.split("->")[1] >= incident_created_at
              external_system.external_hostname = "(#{date.split("->")[0]}~#{date.split("->")[1]})"
              external_system.remote_date = date_message.split(";")[0]
              external_system.scene_date = date_message.split(";")[1]
              return external_system
            end
          end
        end
        external_system.remote_date = 0
        external_system.scene_date = 0
        return external_system
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

      def setup_up_incident_request
        @incident_request = Icm::IncidentRequest.select_all.
            with_request_type(I18n.locale).
            with_workloads.
            with_requested_by(I18n.locale).
            with_urgence(I18n.locale).
            with_impact_range(I18n.locale).
            with_contact.
            with_incident_status(I18n.locale).
            with_priority(I18n.locale).
            with_submitted_by.
            with_category(I18n.locale).
            with_support_group(I18n.locale).
            with_supporter(I18n.locale).
            with_external_system(I18n.locale).
            with_organization(I18n.locale).find(params[:request_id])
      end

      def validate_files(ref_journal)
        flash[:notice] = nil
        now = 0
        flag = true
        flag, now = Irm::AttachmentVersion.validates_repeat?(params[:files]) if params[:files]
        return false, now unless flag
        params[:files].each do |key, value|
          next unless value[:file] && value[:file].original_filename.present?
          flag, now = Irm::AttachmentVersion.validates?(value[:file], Irm::SystemParametersManager.upload_file_limit.to_s)
          return false, now.to_s unless flag
        end if params[:files]
        return true, now
      rescue Exception => e
        logger.debug(e.message)
        return false, now
      end
    end
  end
end