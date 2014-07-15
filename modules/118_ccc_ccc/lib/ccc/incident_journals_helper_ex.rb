module Hli::IncidentJournalsHelperEx
  def self.included(base)
    base.class_eval do
      def list_journals(incident_request)
        journals = Icm::IncidentJournal.enabled.list_all(incident_request.id).without_attribute_change_journal.includes(:incident_histories).default_order
        unless params[:format].eql?('pdf')
          render :partial=>"icm/incident_journals/list_journals",:locals=>{:journals=>journals,:grouped_files=>@request_files}
        else
          journals
        end
      end

      def journals_size(incident_request)
        incident_request.reply_count
      end
    end
  end
end