module Yan::CustomFieldHelperEx
  def self.included(base)

    def show_input_custom_fields_ex(model, columns = 4, only_block = false, for_modal = false,  &block)
      #获取自定义字段
      custom_attributes = model.custom_attributes

      only_required = params[:only_required] || true

      block_fields = {}
      if block_given?
        builder = CustomFieldBuilder.new(&block)
        yield builder
        block_fields = builder.fields
      end
      if only_block
        build_block_html(model, custom_attributes,only_required, block_fields)
      else
        build_html_for_modal(model, custom_attributes, only_required, columns, block_fields)
      end
    end

    def build_html_for_modal(model, custom_attributes, only_required, columns = 4, block_fields)
      column_count = 0
      html = ''
      html += "<input type='hidden' id='custom_field_only_required' name='only_required' value='#{only_required}'/>"

      if custom_attributes.any?
        fields_for model, nil, :builder => CustomFormBuilder do |f|


          custom_attributes.each do |attribute|
            if attribute[:field_type].eql?("SYSTEM_CUX_FIELD")
              attribute_number = attribute[:attribute_name].gsub("sattribute", "").to_i

              if attribute_number >= 21 && attribute_number <= 30 && !allow_to_function?(:additional_info_area1, attribute[:external_system_id])
                next
              elsif attribute_number >= 31 && attribute_number <= 40 && !allow_to_function?(:additional_info_area2, attribute[:external_system_id])
                next
              elsif attribute_number >= 41 && attribute_number <= 50 && !allow_to_function?(:additional_info_area3, attribute[:external_system_id])
                next
              end
            end

            html += "<div class='control-group'>"
            html += "<label class='control-label' data-required='#{attribute[:required_flag]}'>#{attribute[:name]}</label>"
            html += "<div class='controls' data-required='#{attribute[:required_flag]}'>#{show_custom_field(attribute, f)}<span class='help-inline'></span></div>"
            html += "</div>"

          end

        end
      end
      html.html_safe
    end
  end
end