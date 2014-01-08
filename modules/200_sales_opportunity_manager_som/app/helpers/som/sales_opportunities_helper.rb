module Som::SalesOpportunitiesHelper
  def available_percent
    ["0%", "10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%"]
  end

  def involved_productions(selected="")
    checkbox="&nbsp;&nbsp;"
    productions=available_lookup_type('SOM_PRODUCTION_INFO')
    productions.each do |production|
      id=production[1]
      checkbox<<"<input name='som_sales_opportunity[involved_production_info]' #{(selected||'').split(',').include?(id)?'checked':''} value='#{id}' type='checkbox'>
      &nbsp;&nbsp;#{production[0]}&nbsp;&nbsp;&nbsp;&nbsp;"
    end
    checkbox.html_safe
  end

  def involved_productions_name(selected="")
    productions=available_lookup_type('SOM_PRODUCTION_INFO')
    products = (selected||'').split(',')
    names = []
    products.each do |p|
      names << (productions.detect{|i| i[1].eql?(p)}||[""])[0]
    end
    names
  end

  def charge_person_name(id)
    Irm::Person.find(id).full_name
  end

  def available_customers
    Som::PotentialCustomer.select_all.collect{|i| [i.short_name,i.id]}
  end

  def show_sales_customer(customer_id)
    Som::PotentialCustomer.find(customer_id).full_name
  end
end
