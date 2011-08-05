module Irm::TabsHelper
  def available_tab
    Irm::Tab.multilingual.enabled.collect{|i| [i[:name],i.id]}
  end
end
