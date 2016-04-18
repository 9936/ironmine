module Ccc::IncidentJournalsHelperEx
  def self.included(base)
    base.class_eval do
      def list_journals(incident_request)
        if Irm::Person.current.profile.user_license.eql?("SUPPORTER")
          journals = Icm::IncidentJournal.enabled.list_all(incident_request.id).includes(:incident_histories).default_order
        else
          journals = Icm::IncidentJournal.enabled.list_all(incident_request.id).without_attribute_change_journal.includes(:incident_histories).default_order
        end
        unless params[:format].eql?('pdf')
          render :partial=>"icm/incident_journals/list_journals",:locals=>{:journals=>journals,:grouped_files=>@request_files}
        else
          journals
        end
      end

      def journals_size(incident_request)
        ir = Icm::IncidentRequest.find(incident_request.id)
        if Irm::Person.current.profile.user_license.eql?("SUPPORTER")
          count = incident_request.reply_count
        else
          count = ir.incident_journals.without_attribute_change_journal.enabled.size
        end
        count
      end
    end
  end
end