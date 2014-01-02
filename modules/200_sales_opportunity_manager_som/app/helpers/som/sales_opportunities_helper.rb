module Som::SalesOpportunitiesHelper
  def available_percent
    percents=[]
    (0..10).each do |d|
     if d==0
       percents<<d.to_s+"%"
     else
       percents<<d.to_s+"0%"
     end
    end
    percents
  end



  def involved_productions
    checkbox="&nbsp;&nbsp;"
    productions=available_lookup_type('SOM_PRODUCTION_INFO')
    productions.each do |production|
      id=production[1].downcase
      checkbox<<"<input name='som_sales_opportunity[involved_production_info]' value='#{id}' type='checkbox'>
      &nbsp;&nbsp;#{production[0]}&nbsp;&nbsp;&nbsp;&nbsp;"
    end
    checkbox.html_safe
  end
end
