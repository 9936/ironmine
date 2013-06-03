module Irm::ApiToolsHelper
  def available_api_function_groups
    Irm::FunctionGroup.with_api.query_by_status_code("ENABLED").multilingual.collect{|i| [i[:name],i.id]}
  end
end
