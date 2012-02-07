module Irm::PortletsHelper
   def controllers
     Irm::Permission.select("controller, direct_get_flag, id").group(:controller).having("direct_get_flag = ?", 'Y')
   end
end
