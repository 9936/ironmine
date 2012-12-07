module Htc::IncidentRequestModelEx
  def self.included(base)
    base.class_eval do
      validates_presence_of :incident_category_id, :incident_sub_category_id
    end
  end
end