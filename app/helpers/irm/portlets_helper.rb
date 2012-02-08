module Irm::PortletsHelper
   def available_all_controller
     Irm::Permission.select("controller").group(:controller).where("direct_get_flag = ?", 'Y')
   end
end
