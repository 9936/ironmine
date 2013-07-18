module Irm::ApiToolsHelper

  def available_api_functions
    api_functions = Irm::Function.multilingual.api_functions
    api_functions = api_functions.delete_if{|i| !Irm::Person.current.functions.include?(i.id) }
    api_functions.collect{|i| [i[:name],i.id]}
  end


  def required_meaning(code)
    if code.to_s.eql?("Y")
      t(:label_irm_api_tool_doc_yes)
    else
      t(:label_irm_api_tool_doc_no)
    end
  end
end
