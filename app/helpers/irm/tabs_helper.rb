module Irm::TabsHelper
  def available_tab
    Irm::Tab.multilingual.enabled.collect{|i| [i[:name],i.id]}
  end

  def available_tab_style_image
    images = []
    1.upto(17).each do |i|
      images <<[I18n.t(:label_irm_tab_style_image_no,:no=> i.to_s),"img#{i}General"]
    end
    images
  end
end
