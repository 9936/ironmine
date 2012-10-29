module Irm::EventGenerator
  def self.included(base)
    base.class_eval do
      attr_accessor :ignore_event,:event_change_attributes
      after_create {generate_event("CREATE")}
      before_update { self.event_change_attributes = self.changed_attributes.dup}
      after_update {generate_event("UPDATE")}
      def generate_event(event_type)
        Irm::EventManager.publish_bo(self.class.name,self.id,self,event_type) unless self.ignore_event
      end
    end
  end
end
