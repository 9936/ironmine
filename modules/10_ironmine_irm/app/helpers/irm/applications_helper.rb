module Irm::ApplicationsHelper
  def application_tab_str(application)
    if(application.tabs_str.present?)
      return application.tabs_str
    end
    if(application.application_tabs.any?)
      return application.application_tabs.collect{|i| i.tab_id}.join(",")
    else
      return ""
    end
  end

  def application_default_tab_id(application)
    if(application.default_tab_id.present?)
      return application.default_tab_id
    end
    if(application.application_tabs.any?)
       tab = application.application_tabs.detect{|i| i.default_flag.eql?(Irm::Constant::SYS_YES)}
       if tab
         return tab.tab_id
       else
         return nil
       end
    else
      return nil
    end
  end


  def available_applications
    Irm::Application.multilingual.collect{|i| [i[:name],i.id]}
  end
end
