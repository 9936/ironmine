module Com::ConfigItemsHelper
  def show_config_items_attributes_errors(object)
    if object && object.errors && object.errors.any?
      error_msgs=""
      object.errors.full_messages.each {|i| error_msgs<<i.to_s+"<br>"}
      content_tag("div", raw(error_msgs), {:id => "errorDiv_ep", :class => "pbError"})
    end
  end
end
