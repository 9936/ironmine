module SearchableHelper
  def show_search_result(query, search_option_str = "")
    result_box = ""
    results = []
    not_found = true
    return unless query.present?
    Ironmine::Acts::Searchable.searchable_entity.each do |key,value|
      next unless !value.present?||allow_to_function?(value)
      next unless !search_option_str.present? || (search_option_str.present? && (search_option_str.split(" ").include?("ALL") || search_option_str.split(" ").include?(key)))
      search_entity = key.constantize
      if search_entity.searchable_options[:all].present?&&search_entity.respond_to?(search_entity.searchable_options[:all].to_sym)
        results =  search_entity.send(search_entity.searchable_options[:all].to_sym,query)
        if results.any?
          not_found = false if not_found
          result_box << render(:partial=>search_entity.searchable_options[:view],:locals=>{:results=>results} )
        end
      end
    end
    if not_found
      result_box << "<h2>Your search returned no matches.</h2>"
    end
    result_box.html_safe
  end
end