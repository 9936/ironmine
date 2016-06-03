module SearchableHelper
  def show_search_result(param)
    query = param[:q]
    time_limit = get_time_limit(param[:time_option])
    result_box = ""
    no_result = true
    return unless query.present?
    temp_searchable_entity = Ironmine::Acts::Searchable.searchable_entity
    temp_searchable_entity = temp_searchable_entity.sort {|a,b|
      b[0] <=> a[0]
    }
    # Ironmine::Acts::Searchable.searchable_entity.each do |key,value|
    temp_searchable_entity.each do |key,value|
      next unless !value.present?||allow_to_function?(value)
      next unless !param[:search_option_str].present? || (param[:search_option_str].present? && (param[:search_option_str].split(" ").include?("ALL") || param[:search_option_str].split(" ").include?(key)))
      search_entity = key.constantize
      if search_entity.searchable_options[:all].present?&&search_entity.respond_to?(search_entity.searchable_options[:all].to_sym)
        if search_entity.to_s.eql?("Icm::IncidentRequest")
          results =  search_entity.send(search_entity.searchable_options[:all].to_sym, [query, time_limit,param[:incident_request_filter_name],param[:incident_request_filter_value],param[:sort_option]])
        else
          results =  search_entity.send(search_entity.searchable_options[:all].to_sym, [query, time_limit])
        end

        if results.any?
          no_result = false if no_result
          result_box << render(:partial=>search_entity.searchable_options[:view],:locals=>{:results=>results} )
        end
      end
    end

    if no_result
      result_box << <<-BEGIN_HEML
      <div class="alert alert-block no-result" style="margin: 20px 0 0;">
        <p>
          <strong>Oh sorry! Please try again and check as the following:</strong>
        </p>
        <ul style="margin: 10px 5px;">
          <li>#{t :label_search_no_result_alert_1}</li>
          <li>#{t :label_search_no_result_alert_2}</li>
          <li>#{t :label_search_no_result_alert_3}</li>
          <li>#{t :label_search_no_result_alert_4}</li>
        </ul>
      </div>
      BEGIN_HEML
    end

    result_box.html_safe
  end

end