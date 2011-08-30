module Irm::SetWho
  extend ActiveSupport::Concern
  
   included do
      class_inheritable_accessor :record_who, :instance_writer => false
      self.record_who = true
   end
   
    private
    def create #:nodoc:
      if record_who
        write_attribute('created_by', current_user_id) if respond_to?(:created_by) && created_by.nil?
        write_attribute('updated_by', current_user_id) if respond_to?(:updated_by) && updated_by.nil?
        write_attribute('opu_id', current_opu_id) if respond_to?(:opu_id) && opu_id.nil?
        write_attribute('company_id', 0) if respond_to?(:company_id) && company_id .nil?
        write_attribute('status_code', "ENABLED") if respond_to?(:status_code) && status_code.nil?
      end
      super
    end

    def update(*args) #:nodoc:
      if record_who && (!partial_updates? || changed?)

        write_attribute('updated_by', current_user_id) if respond_to?(:updated_by)
      end

      super
    end

    def current_user_id
      ::Irm::Person.current.id
    end

    def current_opu_id
      if self.is_a?(Irm::OperationUnit)
        return self.id
      end
      ::Irm::OperationUnit.current.id
    end
end