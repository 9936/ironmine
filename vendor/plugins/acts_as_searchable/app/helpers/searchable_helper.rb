module SearchableHelper
  def show_search_result(query, search_option_str = "",time_option)
    time_limit = get_time_limit(time_option)
    result_box = ""
    no_result = true
    return unless query.present?
    Ironmine::Acts::Searchable.searchable_entity.each do |key,value|
      next unless !value.present?||allow_to_function?(value)
      next unless !search_option_str.present? || (search_option_str.present? && (search_option_str.split(" ").include?("ALL") || search_option_str.split(" ").include?(key)))
      search_entity = key.constantize
      if search_entity.searchable_options[:all].present?&&search_entity.respond_to?(search_entity.searchable_options[:all].to_sym)
        results =  search_entity.send(search_entity.searchable_options[:all].to_sym, [query, time_limit])
        if results.any?
          no_result = false if no_result
          result_box << render(:partial=>search_entity.searchable_options[:view],:locals=>{:results=>results} )
        end
      end
    end

    if no_result
      result_box << <<-BEGIN_HEML
      <div class="alert alert-block" style="margin: 20px 0 0;">
        <p>
          <strong>Oh sorry! Please try again and check as the following:</strong>
        </p>
        <ul style="margin: 10px 5px;" class="no-result">
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