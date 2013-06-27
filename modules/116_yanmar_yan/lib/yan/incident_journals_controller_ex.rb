module Yan::IncidentJournalsControllerEx
  def self.included(base)
    base.class_eval do

      def edit_additional_info
        @incident_request = Icm::IncidentRequest.find(params[:id])
        respond_to do |format|
          format.html
        end
      end

      def update_additional_info

      end

    end
  end
end