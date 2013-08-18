module Sug::CountriesHelper
  def available_countries
     Sug::Country.enabled.collect{|i|[i.name, i.id]}
  end
end
