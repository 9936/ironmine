module Yan::IncidentRequestModelEx
  def self.included(base)
    base.class_eval do
      validates_presence_of :incident_category_id
      validates_presence_of :incident_sub_category_id
      validates_presence_of :report_source_code
    end
  end
end