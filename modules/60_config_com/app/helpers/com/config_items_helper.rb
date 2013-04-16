module Com::ConfigItemsHelper
  def show_config_items_attributes_errors(object)
    if object && object.errors && object.errors.any?
      error_msgs=""
      object.errors.full_messages.each {|i| error_msgs<<i.to_s+"<br>"}
      content_tag("div", raw(error_msgs), {:id => "errorDiv_ep", :class => "pbError"})
    end
  end

  def build_org_chart(items, root = true)
    if root
      html = "<ul id='org' style='display:none'>"
    else
      html = "<ul>"
    end
    items.each do |item|
      html += "<li>#{item[:item_number]}"
      if item.relation_items.any?
        html += build_org_chart(item.relation_items, false)
      end
      html += "</li>"
    end
    html += "</ul>"
  end

end
