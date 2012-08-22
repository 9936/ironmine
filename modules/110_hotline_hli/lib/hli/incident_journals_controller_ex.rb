module Hli::IncidentJournalsControllerEx
  def self.included(base)
    base.class_eval do
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

        last_journal = Icm::IncidentJournal.
            where("incident_request_id = ?", @incident_request.id).
            where("reply_type IN ('OTHER_REPLY', 'CUSTOMER_REPLY', 'SUPPORTER_REPLY')").
            order("created_at desc").limit(1)
        is_repeat = false
        if last_journal.any?
          last_journal = last_journal.first
          if @incident_journal.message_body == last_journal.message_body &&
              @incident_journal.replied_by == last_journal.replied_by
            is_repeat = true
          end
        end
        respond_to do |format|
          if is_repeat
            flash[:notice] = I18n.t(:label_icm_incident_journal_message_body_not_repeat)
            format.js do
              responds_to_parent do
                render :create_journal do |page|
                end
              end
            end
          else
            flag, now = validate_files(@incident_journal)
            if !flag
              #if now.is_a?(Integer)
                flash[:notice] = I18n.t(:error_file_upload_limit, :m => Irm::SystemParametersManager.upload_file_limit.to_s, :n => now.to_s)
              #else
              #  flash[:notice] = now
              #end
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
              @incident_journal.create_elapse
              @incident_request.save
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
              format.html { redirect_to({:action => "new"}) }
              format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
            else
              flash[:notice] = I18n.t(:label_icm_incident_journal_message_body_not_blank)
              format.js do
                responds_to_parent do
                  render :create_journal do |page|
                  end
                end
              end
              format.html { render :action => "new", :layout=>"application_right"}
              format.xml  { render :xml => @incident_journal.errors, :status => :unprocessable_entity }
            end
          end
        end
      end

      def edit_workload
        @incident_journal = @incident_request.incident_journals.build()

        @supporters = Icm::IncidentWorkload.joins(",#{Irm::Person.table_name} ip").
                    select("DISTINCT ip.id supporter_id, ip.full_name supporter_name, ip.login_name login_name, #{Icm::IncidentWorkload.table_name}.real_processing_time real_processing_time").
                    where("#{Icm::IncidentWorkload.table_name}.incident_request_id = ? AND #{Icm::IncidentWorkload.table_name}.person_id = ip.id", @incident_request.id).
                    where("LENGTH(#{Icm::IncidentWorkload.table_name}.real_processing_time) > 0").
                    where("ip.assignment_availability_flag = ?", Irm::Constant::SYS_YES)

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

      def update_workload
        respond_to do |format|
            Icm::IncidentWorkload.where("incident_request_id = ?", @incident_request.id).each do |t|
              t.destroy
            end
            params[:incident_workloads].each do |work|
              if work[:real_processing_time].blank? || work[:real_processing_time].to_f == 0 || work[:person_id].blank?
                next
              end
              Icm::IncidentWorkload.create(:incident_request_id => @incident_request.id,
                                           :real_processing_time => work[:real_processing_time],
                                           :person_id => work[:person_id])
            end if params[:incident_workloads]

            format.html { redirect_to({:action => "new"}) }
            format.xml  { render :xml => @incident_journal, :status => :created, :location => @incident_journal }
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

      def get_incident_history_data
        history_scope = Icm::IncidentHistory.
            select_all.
            without_some_property_key.
            with_value_label.
            with_created_by.
            only_with_request(params[:request_id]).
            order_by_created_at

        respond_to do |format|
          format.json {
            history_scope.each do |t|
              meaning = t.meaning
              t[:new_value_label] = meaning[:new_meaning]
              t[:old_value_label] = meaning[:old_meaning]
            end
            histories,count = paginate(history_scope)
            render :json=>to_jsonp(histories.to_grid_json([:new_value_label, :old_value_label, :new_value, :old_value,
                                                           :created_by_full_name, :created_at, :property_key],count))
          }
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

        @supporters = Icm::IncidentWorkload.joins(",#{Irm::Person.table_name} ip").
                    select("DISTINCT ip.id supporter_id, ip.full_name supporter_name, ip.login_name login_name, #{Icm::IncidentWorkload.table_name}.real_processing_time real_processing_time").
                    where("#{Icm::IncidentWorkload.table_name}.incident_request_id = ? AND #{Icm::IncidentWorkload.table_name}.person_id = ip.id", @incident_request.id).
                    where("LENGTH(#{Icm::IncidentWorkload.table_name}.real_processing_time) > 0").
                    where("ip.assignment_availability_flag = ?", Irm::Constant::SYS_YES)

        @supporters = Icm::IncidentJournal.where("1=1").
                joins(",#{Irm::Person.table_name} ip").
                select("DISTINCT ip.id supporter_id, ip.full_name supporter_name, ip.login_name login_name, (SELECT iw.real_processing_time FROM #{Icm::IncidentWorkload.table_name} iw WHERE iw.incident_request_id = #{Icm::IncidentJournal.table_name}.incident_request_id AND iw.person_id = ip.id) real_processing_time").
                where("ip.id = #{Icm::IncidentJournal.table_name}.replied_by").
                where("ip.assignment_availability_flag = ?", Irm::Constant::SYS_YES).
                where("#{Icm::IncidentJournal.table_name}.incident_request_id = ?", @incident_request.id) unless @supporters.any?

        respond_to do |format|
          format.html { render :layout => "bootstrap_application_right"}# new.html.erb
          format.xml  { render :xml => @incident_journal }
        end
      end

      private
      def setup_up_incident_request
        @incident_request = Icm::IncidentRequest.select_all.
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
    end
  end
end