module Com::ConfigItemsHelper
  def show_config_items_attributes_errors(object)
    if object && object.errors && object.errors.any?
      error_msgs=""
      object.errors.full_messages.each {|i| error_msgs<<i.to_s+"<br>"}
      content_tag("div", raw(error_msgs), {:id => "errorDiv_ep", :class => "pbError"})
    end
  end


  def build_org_chart(items, parent = nil)
    if parent.present?
      html = "<ul data-tip-text='#{parent[:item_number]}'>"
      #tip_text_pre = parent[:item_number]
    else
      html = "<ul id='org' style='display:none'>"
    end
    items.each do |item|
      if item[:relation_type_name].present?
        html += "<li data-tip-text='#{item[:item_number]}' data-tip-ship='#{item[:relation_type_name]}'>#{item[:item_number]}"
      else
        html += "<li data-tip-text='#{item[:item_number]}'>#{item[:item_number]}"
      end

      if item.relation_items.any?
        html += build_org_chart(item.relation_items, item)
      end
      html += "</li>"
    end
    html += "</ul>"
  end

end
