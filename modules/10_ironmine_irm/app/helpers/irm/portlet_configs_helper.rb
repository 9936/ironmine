module Irm::PortletConfigsHelper
   def available_portal_code
     # Irm::Person.real.collect{|p| ["#{p[:login_name]}(#{p[:full_name]})",p[:id]]}
   end
end
