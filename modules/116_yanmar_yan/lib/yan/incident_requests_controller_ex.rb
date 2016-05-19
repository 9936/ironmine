module Yan::IncidentRequestsControllerEx
  def self.included(base)
    base.class_eval do

      # POST /incident_requests
      # POST /incident_requests.xml
      def create
        @incident_request = Icm::IncidentRequest.new(params[:icm_incident_request])
        @return_url = params[:return_url] if params[:return_url]
        #加入创建事故单的默认参数
        prepared_for_create(@incident_request)
        if @incident_request.estimated_date.present?
          begin
            @incident_request.estimated_date = @incident_request.estimated_date + 18.hour if @incident_request.estimated_date.strftime('%H').to_i == 0
          rescue
            nil
          end
        end
        respond_to do |format|
          flag = true
          flag, now = validate_files(@incident_request) if params[:files].present?
          if !flag
            if now.is_a?(Integer)
              flash[:error] = I18n.t(:error_file_upload_limit, :m => Irm::SystemParametersManager.upload_file_limit.to_s, :n => now.to_s)
            else
              flash[:error] = now
            end
            format.html { render :action => "new", :layout => "application_full" }
            format.xml { render :xml => @incident_request.errors, :status => :unprocessable_entity }
            format.json { render :json => @incident_request.errors, :status => :unprocessable_entity }
          elsif @incident_request.save
            process_files(@incident_request, (@incident_request.if_private_reply && @incident_request.if_private_reply.eql?('Y')) ? 'Y' : 'N' )
            if params[:source_id].present? and params[:relation_type].present?
              create_relation(params[:source_id], @incident_request.id, params[:relation_type])
            end
            #add watchers
            #if params[:cwatcher] && params[:cwatcher].size > 0
            #  params[:cwatcher].collect{|p| [p[0]]}.uniq.each do |w|
            #    watcher = Irm::Person.find(w)
            #    @incident_request.person_watchers << watcher
            #  end
            #end
            parent_list = Yan::ParentPerson.select("parent_person_id").where("person_id = ?", Irm::Person.current.id)
            parent_list.each do |pl|
              watcher = Irm::Person.find(pl[:parent_person_id])
              @incident_request.add_watcher(watcher)
            end

            Icm::IncidentHistory.create({:request_id => @incident_request.id,
                                         :journal_id => "",
                                         :property_key => "incident_request_id",
                                         :old_value => @incident_request.title,
                                         :new_value => ""})

            #如果没有填写support_group, 插入Delay Job任务
            if @incident_request.support_group_id.nil? || @incident_request.support_group_id.blank?
              Delayed::Job.enqueue(Icm::Jobs::GroupAssignmentJob.new(@incident_request.id), [{:bo_code => "ICM_INCIDENT_REQUESTS", :instance_id => @incident_request.id}])
            end
            #投票任务
            Delayed::Job.enqueue(Icm::Jobs::IncidentRequestSurveyTaskJob.new(@incident_request.id))
            format.html { redirect_to({:controller => "icm/incident_journals", :action => "new", :request_id => @incident_request.id, :show_info => Irm::Constant::SYS_YES}) }
            format.xml { render :xml => @incident_request, :status => :created, :location => @incident_request }
            format.json { render :json => @incident_request }
          else
            format.html { render :action => "new", :layout => "application_full" }
            format.xml { render :xml => @incident_request.errors, :status => :unprocessable_entity }
            format.json { render :json => @incident_request.errors, :status => :unprocessable_entity }
          end
        end
      end

      def get_attend_incident
        # 获取可选事故单信息
        incident = Icm::IncidentRequest.
            joins("LEFT OUTER JOIN #{Icm::IncidentJournal.table_name} iij on iij.incident_request_id = #{Icm::IncidentRequest.table_name}.id").
            where("DATE_FORMAT(iij.created_at, '%Y-%m-%d') = ? AND iij.replied_by = ?",params[:date_time],Irm::Person.current.id).
            group("request_number").order("request_number ASC").collect{|i| {
            :id => i.id,
            :request_number => i.request_number}
        }

        render json: {:result=>incident}
      end

      private
      def process_files(ref_request, private_flag = 'N')
        @files = []
        params[:files].each do |key, value|
          @files << Irm::AttachmentVersion.create({:source_id => ref_request.id,
                                                   :source_type => ref_request.class.name,
                                                   :private_flag => private_flag,
                                                   :data => value[:file],
                                                   :description => value[:description]}) if (value[:file]&&!value[:file].blank?)
        end if params[:files]

        @files.each do |f|
          puts f.errors
        end
      end
    end
  end
end