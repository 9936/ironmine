module Som::SalesOpportunitiesHelper
  def available_percent
    possibility = []
    (0..100).step(10){|i| possibility<<["#{i}%",i]}
    possibility
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

  def translate_person_role(id)
     Irm::Role.multilingual.find(id)[:name] if id
  end

  def available_customers
    Som::PotentialCustomer.select_all.collect{|i| [i.short_name,i.id]}
  end

  def show_sales_customer(customer_id)
    Som::PotentialCustomer.find(customer_id).full_name
  end

  def communicate_count(sales_id)
    sales_opportunity =Som::SalesOpportunity.find(sales_id)
    sales_opportunity.communicate_infos.size
  end

  def last_communicate(sales_id)
    sales_opportunity =Som::SalesOpportunity.find(sales_id)
    last_communicate = sales_opportunity.communicate_infos.last
    last_communicate.created_at.strftime('%Y-%m-%d') unless last_communicate.nil?
  end

  def translate_status(status)
    if status.eql?("QUOTE")
      t("label_som_sales_opportunity_sales_status_quote")
    elsif status.eql?("BID")
      t("label_som_sales_opportunity_sales_status_bid")
    elsif status.eql?("PROJECT")
      t("label_som_sales_opportunity_sales_status_project")
    elsif status.eql?("BUSINESS")
      t("label_som_sales_opportunity_sales_status_business")
    else
      t("label_som_sales_opportunity_sales_status_cancel")
    end
  end

  def sales_opportunities_status
    m = {}
    Irm::LookupValue.query_by_lookup_type("SOM_PRODUCTION_STATUS").order_by_sequence.multilingual.each{|i| m[i.lookup_code]=i[:meaning]}
    m
  end

  def sales_opportunities_year_check
    m = {}
    Som::SalesOpportunity.select("year(start_at) start_at_year").group("year(start_at)").order("start_at_year desc").each{|i| m[i["start_at_year"]]= i["start_at_year"]}
    m
  end

  def sales_opportunities_possibility_check
    {"0_3"=>"0%~30%","3_5"=>"30%~50%","5_7"=>"50%~70%","7_10"=>"70%~100%","9.9_10"=>"100%"}
  end

  def custom_filter_items(field,meaning,items)
    html = %(<div class="filter-item" id="#{field}"><h5>#{meaning}:</h5>)
    html << %(<div class="custom-checkbox"><label class="btn" value="all" data-all="true">#{t(:label_som_sales_opportunity_sales_status_all)}</label></div>)
    items.each do |value,label|
      html <<  %(<div class="custom-checkbox"><label class="btn" value="#{value}">#{label}</label></div>)
    end
    html << "</div>"
    html.html_safe
  end

end
