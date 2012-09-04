module Hli::IncidentRequestsControllerEx
  def self.included(base)
    base.class_eval do
      before_filter :setup_up_incident_request, :only => [:update]
      before_filter :backup_incident_request ,:only =>[:update]

      def get_data
        return_columns = [:request_number,
                          :organization_id,
                          :organization_id_label,
                          :title,
                          :incident_status_id,
                          :incident_status_id_label,
                          :close_flag,
                          :requested_by,
                          :requested_by_label,
                          :support_group_id,
                          :support_group_id_label,
                          :support_person_id,
                          :support_person_id_label,
                          :last_response_date,
                          :external_system_id,
                          :external_system_id_label,
                          :incident_category_id,
                          :incident_category_id_label,
                          :incident_sub_category_id,
                          :incident_sub_category_id_label,
                          :kb_flag,
                          :reply_flag,
                          :reply_count,
                          :background_color]
        bo = Irm::BusinessObject.where(:business_object_code=>"ICM_INCIDENT_REQUESTS").first

        incident_status_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"incident_status_id")

        incident_requests_scope = eval(bo.generate_query_by_attributes(return_columns,true)).with_reply_flag(Irm::Person.current.id).
            filter_system_ids(Irm::Person.current.system_ids).relate_person(Irm::Person.current.id)

        if params[:order_name]
          order_value = params[:order_value] ? params[:order_value] : "DESC"
          incident_requests_scope = incident_requests_scope.order("#{params[:order_name]} #{order_value}")
        else
          incident_requests_scope = incident_requests_scope.order("last_response_date DESC")
        end

        incident_requests_scope = incident_requests_scope.select("#{incident_status_table_alias}.close_flag, #{incident_status_table_alias}.background_color background_color")  if incident_status_table_alias.present?
        incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.request_number",params[:request_number])
        incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.title",params[:title])
        incident_requests_scope = incident_requests_scope.match_value("#{Irm::ExternalSystem.view_name}.system_name",params[:external_system_id_label])

        respond_to do |format|
          format.json {
            incident_requests,count = paginate(incident_requests_scope)
            render :json=>to_jsonp(incident_requests.to_grid_json(return_columns,count))
          }
          format.html {
            @datas,@count = paginate(incident_requests_scope)
          }
          format.xls{
            incident_requests = data_filter(incident_requests_scope)
            send_data(data_to_xls(incident_requests,
                                  [
                                   { :key => "request_number", :label => t(:label_icm_incident_request_request_number_shot)},
                                   { :key => "title",:label => t(:label_icm_incident_request_title)},
                                   { :key => "reply_count", :label =>"#"},
                                   { :key => "external_system_id_label", :label => t(:label_irm_external_system)},
                                   { :key => "priority_id_label", :label => t(:label_icm_incident_request_priority)},
                                   { :key => "submitted_date", :label => t(:label_icm_incident_request_submitted_date)},
                                   { :key => "last_response_date", :label => t(:label_icm_incident_request_last_date)},
                                   { :key => "incident_status_id_label", :label => t(:label_icm_incident_request_incident_status)},
                                   { :key => "support_person_id_label", :label => t(:label_icm_incident_request_support_person)}]
                      ))
          }
        end
      end

      def get_help_desk_data
        return_columns = [:request_number,
                          :organization_id,
                          :organization_id_label,
                          :title,
                          :incident_status_id,
                          :incident_status_id_label,
                          :close_flag,
                          :requested_by,
                          :support_person_id,
                          :support_person_id_label,
                          :requested_by_label,
                          :last_request_date,
                          :priority_id_label,
                          :external_system_id_label,
                          :external_system_id,
                          :kb_flag,
                          :estimated_date,
                          :incident_category_id,
                          :incident_category_id_label,
                          :incident_sub_category_id,
                          :incident_sub_category_id_label,
                          :reply_flag]
        bo = Irm::BusinessObject.where(:business_object_code=>"ICM_INCIDENT_REQUESTS").first

        incident_status_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"incident_status_id")
        supporter_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"support_person_id")
        incident_category_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"incident_category_id")
        incident_sub_category_table_alias = Irm::ObjectAttribute.get_ref_bo_table_name(bo.id,"incident_sub_category_id")

        incident_requests_scope = eval(bo.generate_query_by_attributes(return_columns,true)).with_reply_flag(Irm::Person.current.id).
            filter_system_ids(Irm::Person.current.system_ids).relate_person(Irm::Person.current.id)

        session[:current_external_system] = params[:external_system_id_param] if params[:external_system_id_param]
        unless session[:current_external_system].blank?
          incident_requests_scope = incident_requests_scope.where("#{Icm::IncidentRequest.table_name}.external_system_id = ?", session[:current_external_system])
        end

        if params[:order_name]
          order_value = params[:order_value] ? params[:order_value] : "DESC"
          incident_requests_scope = incident_requests_scope.order("#{params[:order_name]} #{order_value}")
        else
          incident_requests_scope = incident_requests_scope.order("last_response_date DESC")
        end

        incident_requests_scope = incident_requests_scope.select("#{incident_status_table_alias}.close_flag,#{incident_status_table_alias}.display_color")  if incident_status_table_alias.present?
        #incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.request_number",params[:request_number])
        incident_requests_scope = incident_requests_scope.match_value("#{Icm::IncidentRequest.table_name}.title",params[:title])
        incident_requests_scope = incident_requests_scope.match_value("#{incident_status_table_alias}.name", params[:incident_status_id_label])
        incident_requests_scope = incident_requests_scope.match_value("#{incident_category_table_alias}.name", params[:incident_category_id_label])
        incident_requests_scope = incident_requests_scope.match_value("#{incident_sub_category_table_alias}.name", params[:incident_sub_category_id_label])
        incident_requests_scope = incident_requests_scope.match_value("#{Irm::ExternalSystem.view_name}.system_name",params[:external_system_id_label])
        incident_requests_scope = incident_requests_scope.match_value("#{supporter_table_alias}.full_name",params[:support_person_id_label])

        if params[:request_number] && !params[:request_number].blank?
          results = Sunspot.search(Icm::IncidentRequest) do |s|
            s.keywords params[:request_number]
            s.paginate :per_page => 30000
          end.results
          incident_requests_scope = incident_requests_scope.where("#{Icm::IncidentRequest.table_name}.id IN (?)", results.collect(&:id))
        end

        respond_to do |format|
          format.json {
            incident_requests,count = paginate(incident_requests_scope)
            render :json=>to_jsonp(incident_requests.to_grid_json(return_columns,count))
          }
          format.html {
            @datas,@count = paginate(incident_requests_scope)
          }
          format.xls{
            incident_requests = data_filter(incident_requests_scope)
            send_data(data_to_xls(incident_requests,
                                  [
                                   { :key => "request_number", :label => t(:label_icm_incident_request_request_number_shot)},
                                   { :key => "title",:label => t(:label_icm_incident_request_title)},
                                   { :key => "reply_count", :label =>"#"},
                                   { :key => "external_system_id_label", :label => t(:label_irm_external_system)},
                                   { :key => "priority_id_label", :label => t(:label_icm_incident_request_priority)},
                                   { :key => "submitted_date", :label => t(:label_icm_incident_request_submitted_date)},
                                   { :key => "last_response_date", :label => t(:label_icm_incident_request_last_date)},
                                   { :key => "incident_status_id_label", :label => t(:label_icm_incident_request_incident_status)},
                                   { :key => "support_person_id_label", :label => t(:label_icm_incident_request_support_person)}]
                      ))
          }

        end
      end

      def cancel_request
        ir = Icm::IncidentRequest.find(params[:id])
        respond_to do |format|
          if ir.update_attribute(:status_code, "OFFLINE")
            Icm::IncidentHistory.create({:request_id => ir.id,
                                         :journal_id=> "",
                                         :property_key=> "cancel_request",
                                         :old_value=> "ENABLED",
                                         :new_value=> "OFFLINE"})
          end
          format.html { redirect_to({:controller => "icm/incident_journals", :action => "new", :request_id => ir.id}) }
        end
      end

      def enable_request
        ir = Icm::IncidentRequest.find(params[:id])
        respond_to do |format|
          if ir.update_attribute(:status_code, "ENABLED")
            Icm::IncidentHistory.create({:request_id => ir.id,
                                         :journal_id=> "",
                                         :property_key=> "enable_request",
                                         :old_value=> "OFFLINE",
                                         :new_value=> "ENABLED"})
          end
          format.html { redirect_to({:action => "new", :controller => "icm/incident_journals", :request_id => ir.id}) }
        end
      end

      def assign_request

        incident_requests = []
        params[:incident_request_ids].split(",").each do |icid|
          incident_requests << Icm::IncidentRequest.query(icid).first
        end
        incident_requests.compact!
        incident_requests.each do |req|
          if params[:support_group_id].present?
            if params[:support_person_id]
                perform_assignment(req.id,{:support_group_id=>params[:support_group_id],:support_person_id=>params[:support_person_id],:assign_dashboard=>true,:assign_dashboard_operator=>Irm::Person.current.id})
            else
              perform_assignment(req.id,{:support_group_id=>params[:support_group_id],:assign_dashboard=>true,:assign_dashboard_operator=>Irm::Person.current.id})
            end
          else
            perform_assignment(req.id,{})

          end

          req.add_watcher(Irm::Person.current)
        end
        @count = incident_requests.size
        respond_to do |format|
          if params[:from_incident_request].present?
            format.html { redirect_to({:controller => "icm/incident_journals", :action => "new", :request_id => incident_requests.first}) }
          else
            format.html { redirect_to({:action => "assign_dashboard"}) }
          end
          #format.js
        end
      end

      def short_create
        @incident_request = Icm::IncidentRequest.new(params[:icm_incident_request])
        #@incident_request.urgence_id = Icm::UrgenceCode.default_id
        @incident_request.incident_status_id = Icm::IncidentStatus.default_id
        #@incident_request.impact_range_id = Icm::ImpactRange.default_id
        #加入创建事故单的默认参数
        prepared_for_create(@incident_request)
        @incident_request.summary = "<pre>" + @incident_request.summary+"</pre>" unless limit_device?
        respond_to do |format|
          if @incident_request.valid?

            if @incident_request.save
              #如果没有填写support_group, 插入Delay Job任务
              if @incident_request.support_group_id.nil? || @incident_request.support_group_id.blank?
                Delayed::Job.enqueue(Icm::Jobs::GroupAssignmentJob.new(@incident_request.id),
                                     [{:bo_code => "ICM_INCIDENT_REQUESTS", :instance_id => @incident_request.id}])
              end
              Icm::IncidentHistory.create({:request_id => @incident_request.id,
                                           :journal_id=> "",
                                           :property_key=> "incident_request_id",
                                           :old_value=> @incident_request.title,
                                           :new_value=> ""})
              format.html { redirect_to({:controller=>"icm/incident_journals",:action=>"new",:request_id=>@incident_request.id,:show_info=>Irm::Constant::SYS_YES}) }
              format.xml  { render :xml => @incident_request, :status => :created, :location => @incident_request }
            else
              format.html { render :action => "new", :layout => "bootstrap_application_full" }
              format.xml  { render :xml => @incident_request.errors, :status => :unprocessable_entity }
            end
          else
            #@incident_request.errors[:requested_by] << I18n.t(:error_icm_requested_by_can_not_blank)
            format.html { render :action => "new", :layout => "bootstrap_application_full" }
            format.xml  { render :xml => @incident_request.errors, :status => :unprocessable_entity }
          end
        end
      end

      private
      def prepared_for_create(incident_request)
        incident_request.submitted_by = Irm::Person.current.id
        incident_request.submitted_date = Time.now
        incident_request.last_request_date = Time.now
        incident_request.last_response_date = 1.minute.ago
        incident_request.next_reply_user_license="SUPPORTER"

        #HOTLINE项目中，暂时用不到请求类型和来源类型，先进行默认
        incident_request.request_type_code = "REQUESTED_TO_PERFORM"
        incident_request.report_source_code = "CUSTOMER_SUBMIT"
        if incident_request.incident_status_id.nil?||incident_request.incident_status_id.blank?
          incident_request.incident_status_id = Icm::IncidentStatus.default_id
        end
        if incident_request.request_type_code.nil?||incident_request.request_type_code.blank?
          incident_request.request_type_code = "REQUESTED_TO_CHANGE"
        end

        if incident_request.report_source_code.nil?||incident_request.report_source_code.blank?
          incident_request.report_source_code = "CUSTOMER_SUBMIT"
        end
        if incident_request.requested_by.present?
          incident_request.contact_id = incident_request.requested_by
        end
        if incident_request.contact_number.present? && incident_request.contact_number.eql?(I18n.t(:label_icm_incident_request_contact_number_tip_a)) ||
            incident_request.contact_number.eql?(I18n.t(:label_icm_incident_request_contact_number_tip_b))
          if incident_request.hotline.eql?(Irm::Constant::SYS_YES)
            incident_request.contact_number = nil
          else
            incident_request.contact_number = "NULL"
          end
        end
        #必须手工填写联系方式
    #    if !incident_request.contact_number.present?&&incident_request.contact_id.present?
    #      incident_request.contact_number = Irm::Person.find(incident_request.contact_id).bussiness_phone
    #    end

        if limit_device?
          incident_request.summary = "<pre>"+incident_request.summary+"</pre>"
        end
      end

      def validate_files(ref_request)
        flash[:notice] = nil
        now = 0
        flag = true
        flag, now = Irm::AttachmentVersion.validates_repeat?(params[:files]) if params[:files]
        return false, now unless flag
        params[:files].each do |key,value|
          next unless value[:file] && value[:file].original_filename.present?
          flag, now = Irm::AttachmentVersion.validates?(value[:file], Irm::SystemParametersManager.upload_file_limit)
          return false, now unless flag
        end if params[:files]
        return true, now
      rescue
        return false, now
      end

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
            with_organization(I18n.locale).find(params[:id])
      end

      def backup_incident_request
        @incident_request_bak = @incident_request.dup
      end

      def perform_assignment(incident_request_id, assign_options)
        # 待分配事故单
        request = Icm::IncidentRequest.unscoped.find(incident_request_id)
        Irm::Person.current = Irm::Person.find(request.requested_by)
        # 事故单所属系统
        system = nil
        system = Irm::ExternalSystem.where(:id=>request.external_system_id).first if request.external_system_id.present?

        # 如果事故单已经被分配,则中断分自动分配
        return if request.support_group_id.present?&&request.support_person_id.present?

        # assign_options为分配选项
        assign_result =  assign_options if  assign_options&&assign_options.is_a?(Hash)

        # assign_result 最后分配结果
        assign_result ||= {}

        # person  提单人
        person = Irm::Person.find(request.requested_by)

        # 如果分配选项中指定了支持组,则对支持组进行验证
        # 确认当前支持组是否有人满足处理该事故单的条件
        if assign_result[:support_group_id].present?
          return unless check_support_group(assign_result[:support_group_id],system.id)
        end


        # 指定事故单处理组
        unless request.support_group_id.present?||assign_result[:support_group_id].present?
          assign_result[:support_person_id] = nil
          # 在能处理当前系统事故单的待命组中选择合适的支持组
          support_group_scope = Icm::SupportGroup.oncall.assignable

          support_group_ids = support_group_scope.collect{|i| i.id}

          # 如果不存可用的支持组，则中断自动分配
          return unless support_group_ids.any?

          # 1 按照事故单提交人直接查找
          groups = Icm::SupportGroup.query_by_ids(support_group_ids).support_for_person(person.id)

          # 2 按照事故单所属分类查找
          if !groups.any?&&request.incident_category_id.present?
            groups = Icm::SupportGroup.query_by_ids(support_group_ids).support_for_category(request.incident_category_id)
          end

          # 3 按照事故单所属系统查找
          unless groups.any?||system.nil?
            groups = Icm::SupportGroup.query_by_ids(support_group_ids).support_for_system(system.id)
          end

          # 4 按照事故单提单人所属组
          unless groups.any?
            groups = Icm::SupportGroup.query_by_ids(support_group_ids).support_for_group(person.id)
          end

          # 5 按照事故单提单人所属组或子组
          unless groups.any?
            groups = Icm::SupportGroup.query_by_ids(support_group_ids).support_for_group_explosion(person.id)
          end

          # 6 按照事故单提单人所属角色
          unless groups.any?
            groups = Icm::SupportGroup.query_by_ids(support_group_ids).support_for_role(person.id)
          end

          # 7 按照事故单提单人所属角色或子角色
          unless groups.any?
            groups = Icm::SupportGroup.query_by_ids(support_group_ids).support_for_role_explosion(person.id)
          end

          # 8 按照事故单提单人所属组织
          unless groups.any?
            groups = Icm::SupportGroup.query_by_ids(support_group_ids).support_for_organization(person.id)
          end

          # 9 按照事故单提单人所属子组织
          unless groups.any?
            groups = Icm::SupportGroup.query_by_ids(support_group_ids).support_for_organization_explosion(person.id)
          end

          if groups.any?
            assign_result[:support_group_id] = groups.first.id
          else
            return
          end
        end
        # 在取得合适的支持组后，分配事故单处理人
        if assign_result[:support_group_id].present?
          unless assign_result[:support_person_id].present?
            support_group = Icm::SupportGroup.query(assign_result[:support_group_id]).first
            assign_result.merge!(:support_person_id => support_group.assign_member_id)
          end
        else
          return
        end
        #get the support information
        #generate incident journal
        if assign_result[:support_group_id].present?#&&assign_result[:support_person_id].present?
          ActiveRecord::Base.transaction do
            generate_journal(request,assign_result)
          end
        end
      end

      #为事故单生成回复
      def generate_journal(request,assign_result)
        person = Irm::Person.query(Irm::OperationUnit.current.primary_person_id).first
        if assign_result[:assign_dashboard]
          person = Irm::Person.find(assign_result[:assign_dashboard_operator])
        end
        Irm::Person.current = person
        language_code = person.language_code
        request_attributes = {:support_group_id=>assign_result[:support_group_id],
                              :support_person_id=>assign_result[:support_person_id],
                              :upgrade_group_id=>assign_result[:support_person_id],
                              :upgrade_person_id=>assign_result[:support_person_id],
                              :charge_group_id=>assign_result[:support_person_id],
                              :charge_person_id=>assign_result[:support_person_id]}
        journal_attributes = {:replied_by=>person.id,:reply_type=>"ASSIGN"}
        incident_status_id = Icm::IncidentStatus.transform(request.incident_status_id,journal_attributes[:reply_type])
        request_attributes.merge!(:incident_status_id=>incident_status_id)
        if assign_result[:assign_dashboard]
          journal_attributes.merge!(:message_body=>I18n.t(:label_icm_incident_assign_dashboard,{:locale=>language_code}))
        else
          journal_attributes.merge!(:message_body=>I18n.t(:label_icm_incident_auto_assign,{:locale=>language_code}))
        end
        incident_journal = Icm::IncidentJournal::generate_journal(request,request_attributes,journal_attributes)
      end
    end
  end
end