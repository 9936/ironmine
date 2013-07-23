module Emw::InterfacesHelper
  def available_ebs_modules
    Emw::EbsModule.enabled.collect{|i|[i.name, i.id]}
  end
end
