module Yan::IncidentJournalsControllerEx
  def self.included(base)
    base.class_eval do

      def edit_additional_info
        @incident_request = Icm::IncidentRequest.find(params[:request_id])
      end

      def update_additional_info

      end

    end
  end
end