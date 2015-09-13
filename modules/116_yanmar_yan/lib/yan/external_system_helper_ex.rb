module Yan::ExternalSystemHelperEx
  def self.included(base)
    base.class_eval do
      #GPACK-DEV,GPACK-YA DEV, GPACK-YADIN DEV, GPACK-YID DEV
      def dev_sys
        systems = Irm::ExternalSystem.multilingual.order_with_name.with_dev_sys.enabled
        systems.collect{|p| [p[:system_name], p.id]}
      end
    end
  end
end