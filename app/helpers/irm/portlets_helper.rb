module Irm::PortletsHelper
   def available_all_controller
     Irm::Permission.select("controller").group(:controller).where("#{Irm::Permission.table_name}.params_count = ? AND #{Irm::Permission.table_name}.direct_get_flag = ?",0,Irm::Constant::SYS_YES)
   end
end
