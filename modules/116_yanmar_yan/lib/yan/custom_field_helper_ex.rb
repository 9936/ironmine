module Yan::CustomFieldHelperEx
  def self.included(base)

    #参数only_block的值可为true | false.默认为false
    #only_block => false 时默认显示格式和block自定义的格式合并显示；
    #only_block => true 时，只显示block下定义的格式代码
    def show_input_custom_fields_2(model, columns = 4, only_block = false,  &block)
      puts("++++++++++++++++++++++++++++A")
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
        build_html_2(model, custom_attributes, only_required, columns, block_fields)
      end
    end

    def show_custom_field_info(model, columns = 6)
      #获取出自定义字段
      custom_attributes = model.custom_attributes

      column_count = 0
      html = ''
      if custom_attributes.any?
        html += "<tr data-custom-flag='Y'>"
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

          if column_count > 0 and column_count%columns == 0
            html += "</tr><tr data-custom-flag='Y'>"
          end
          html += "<td class='label-col'><label>#{attribute[:name]}</label></td>"
          html += "<td class='data-col'>#{hand_value attribute[:category], model[attribute[:attribute_name].to_sym]}</td>"
          column_count += 2
        end
        #将填不满的给补齐
        if column_count % columns != 0
          colspan = columns - column_count % columns
          html += "<td colspan='#{colspan}'></td>"
        end

        html += "</tr>"
      end
      html.html_safe
    end

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

    #仅仅获取block中自定义的代码块
    def build_block_html(model, custom_attributes, only_required, block_fields)
      html = ""

      html += "<input type='hidden' id='custom_field_only_required' name='only_required' value='#{only_required}'/>"

      if block_fields.present? and custom_attributes.any?
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
            if block_fields[attribute[:attribute_name].to_sym].present? and block_fields[attribute[:attribute_name].to_sym][:block]
               html += capture(attribute[:name], show_custom_field(attribute, f, block_fields[attribute[:attribute_name].to_sym][:options]) ,attribute, f, &block_fields[attribute[:attribute_name].to_sym][:block])
            end
          end
        end
      end
      html.html_safe
    end

    def build_html_2(model, custom_attributes, only_required, columns = 4, block_fields)
      column_count = 0
      html = ''
      html += "<input type='hidden' id='custom_field_only_required' name='only_required' value='#{only_required}'/>"

      if custom_attributes.any?
        fields_for model, nil, :builder => CustomFormBuilder do |f|
          html += "<tr>"
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

            if column_count > 0 and column_count%columns == 0
              html += "</tr><tr>"
            end
            if block_fields[attribute[:attribute_name].to_sym].present?
              if block_fields[attribute[:attribute_name].to_sym][:block]
                tmp_html = capture(attribute[:name], show_custom_field(attribute, f) ,attribute, &block_fields[attribute[:attribute_name].to_sym][:block])

                colspan = 0
                if tmp_html.match(/label-col/)
                   colspan += tmp_html.match(/label-col/).size
                end

                if tmp_html.match(/data-\d{1}col/)
                  if tmp_html.match(/data-\d{1}col/)[0].match(/\d{1}/)
                    colspan += tmp_html.match(/data-\d{1}col/)[0].match(/\d{1}/)[0].to_i
                  else
                    colspan += 1
                  end
                end

                if colspan > 0 and column_count % colspan < colspan
                  html += "</tr><tr>"
                  html += tmp_html
                  column_count += columns - column_count % columns
                  column_count += colspan
                else
                  html += tmp_html
                  column_count += colspan
                end
              end
            else
              html += "<td class='label-col' data-required='#{attribute[:required_flag]}'><label>#{attribute[:name]}</label></td>"
              html += "<td class='data-col' data-required='#{attribute[:required_flag]}'>#{show_custom_field(attribute, f)}</td>"
              column_count += 2
            end
          end
          #将填不满的给补齐
          ((custom_attributes.count * 2 % columns)/2).times do
            html += "<td class='label-col'></td>"
            html += "<td class='data-col'></td>"
          end
          html += "</tr>"
        end
      end
      html.html_safe
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
              elsif attribute_number >= 1 && attribute_number <= 20
                next
              end
            else
              #不显示PUBLIC
              next
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