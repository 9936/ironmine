module Irm::Timetriggerable
  #用来扩展ActiveRecord::Base,添加Timetrigger支持
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_timetrigger(schedule_days = 2)
      return if self.included_modules.include?(::Irm::Timetriggerable::InstanceMethods)
      send :include, ::Irm::Timetriggerable::InstanceMethods

      cattr_accessor :schedule_days

      self.schedule_days = schedule_days

      class_eval do
        attr_accessor :time_trigger

        after_save :save_time_trigger

        private
          def save_time_trigger
            current_time_trigger = Irm::TimeTrigger.query_target(self.id, self.class.name).first
            if current_time_trigger.present?
              time_trigger = Irm::TimeTrigger.new(self.time_trigger)
              time_trigger.target_id = self.id
              time_trigger.target_type = self.class.name
              time_trigger.schedule_days = self.schedule_days
              time_trigger.save
            else
              current_time_trigger.update_attributes(self.time_trigger)
            end
          end
      end


    end
  end

  module InstanceMethods
    def self.included(base)
      base.extend ClassMethods
    end
  end
end