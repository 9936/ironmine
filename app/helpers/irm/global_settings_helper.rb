module Irm::GlobalSettingsHelper
  def available_timezone
    Irm::LookupValue.query_by_lookup_type("TIMEZONE").multilingual.collect{|m| [m[:meaning], m.lookup_code]}
  end
  def available_themes
    [["default", "default"], ["salesforce", "salesforce"]]
  end

  def errors_for(errors)

    if errors && errors.size>0
      error_msg=""
      errors.each do |error|
        error_msg<<error[0]+":" +error[1].messages.values.join(',')+"<br>"
      end
      content_tag("div", raw(t(:error_invalid_data) + "<br>" + t(:check_error_msg_and_fix)+"<br>"+error_msg), {:id => "errorDiv_ep", :class => "pbError"})
    end
  end
end
