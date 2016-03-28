module Yan::IncidentRequestModelEx
  def self.included(base)
    base.class_eval do
      attr_accessor :if_private_reply

      validates_presence_of :incident_category_id
      validates_presence_of :incident_sub_category_id
      validates_presence_of :report_source_code

      scope :select_all_for_reports,lambda{
                         select("#{table_name}.id,#{table_name}.request_number,#{table_name}.title,#{table_name}.summary,#{table_name}.submitted_date,#{table_name}.estimated_date,#{table_name}.last_response_date")
                       }
    end
  end
end