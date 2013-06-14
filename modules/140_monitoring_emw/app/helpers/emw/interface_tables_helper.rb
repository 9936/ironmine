module Emw::InterfaceTablesHelper
  def available_data_types
    [[t(:label_emw_interface_column_data_type_string), "STRING"],
     [t(:label_emw_interface_column_data_type_number), "NUMBER"],
     [t(:label_emw_interface_column_data_type_text), "TEXT"]
    ]
  end
end
