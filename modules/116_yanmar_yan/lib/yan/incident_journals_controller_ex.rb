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
    end
  end
end