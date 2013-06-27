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
          html += "<div class='control-group'>"
          custom_attributes.each do |attribute|
            if column_count > 0 and column_count%columns == 0
              html += "</div><div class='control-group'>"
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
                  html += "</div><div class='control-group'>"
                  html += tmp_html
                  column_count += columns - column_count % columns
                  column_count += colspan
                else
                  html += tmp_html
                  column_count += colspan
                end
              end
            else
              html += "<label class='control-label' data-required='#{attribute[:required_flag]}'><label>#{attribute[:name]}</label></div>"
              html += "<div class='controls' data-required='#{attribute[:required_flag]}'>#{show_custom_field(attribute, f)}<span class='help-inline'></span></div>"
              column_count += 2
            end
          end
          #将填不满的给补齐
          ((custom_attributes.count * 2 % columns)/2).times do
            html += "<label class='control-label'></label>"
            html += "<div class='controls'><span class='help-inline'></span></div>"
          end
          html += "</div>"
        end
      end
      html.html_safe
    end
  end
end