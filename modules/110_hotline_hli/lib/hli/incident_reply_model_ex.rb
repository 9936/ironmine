module Hli::IncidentReplyModelEx
  def self.included(base)
    base.class_eval do
      attr_accessor :support_group_id, :support_person_id, :external_system_id,:incident_category_id,:incident_sub_category_id,
                      :incident_status_id, :hotline, :title, :summary, :contact_number, :contact_id,
                      :client_info, :requested_by, :submitted_by,
                      :impact_range_id, :urgence_id, :priority_id

      def attributes
        attrs = {}
        Icm::IncidentReply.all_attributes.each do |key|
          value = send(key)
          attrs.merge!({key=>value}) if(value&&!value.blank?)
        end
        attrs
      end

      def self.all_attributes
        return [:support_group_id, :support_person_id, :external_system_id,:incident_category_id,:incident_sub_category_id,
              :incident_status_id, :hotline, :title, :summary, :contact_number, :contact_id,
              :client_info, :requested_by, :submitted_by,
              :impact_range_id, :urgence_id, :priority_id]
      end
    end
  end
end