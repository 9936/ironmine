module Isp::CheckParametersHelper
  def available_param_types
    [[t(:label_isp_parameter_param_type_default), "DEFAULT"], [t(:label_isp_parameter_param_type_input), "INPUT"]]
  end

  def param_type_meaning(type)
    case type
      when "DEFAULT"
        return t(:label_isp_parameter_param_type_default)
      when "INPUT"
        return t(:label_isp_parameter_param_type_input)
      else
        return ""
    end
  end

  def available_data_types
    [[t(:label_isp_parameter_data_string), "STRING"], [t(:label_isp_parameter_data_number), "NUMBER"]]
  end

  def data_type_meaning(type)
    case type
      when "STRING"
        return t(:label_isp_parameter_data_string)
      when "NUMBER"
        return t(:label_isp_parameter_data_number)
      else
        return ""
    end
  end

end
