module CustomFieldHelper

  def show_custom_field(attribute, form)
    if form
      case attribute[:category]
        when "TEXT"
          return form.text_field attribute[:attribute_name].to_sym, :required=> attribute[:required_flag].eql?('Y')? true : false
        when "DATE_TIME"
          return form.date_field attribute[:attribute_name].to_sym, :size=>12,:class=>"date",:with_time => true,:required=> attribute[:required_flag].eql?('Y')? true : false
        when "DATE"
          return form.date_field attribute[:attribute_name].to_sym,:size=>12,:class=>"date",:required=> attribute[:required_flag].eql?('Y')? true : false
        when "CHECK_BOX"
          return form.check_box attribute[:attribute_name].to_sym, :required=> attribute[:required_flag].eql?('Y')? true : false
        when "PICK_LIST"
          choices = attribute[:pick_list_options].gsub(/\r\n/, ',').split(',').collect{|i|[i,i]}
          return form.blank_select attribute[:attribute_name].to_sym, choices, :required=> attribute[:required_flag].eql?('Y')? true : false
        when "PICK_LIST_MULTI"
          choices = attribute[:pick_list_options].gsub(/\r\n/, ',').split(',').collect{|i|[i,i]}
          return form.select attribute[:attribute_name].to_sym, choices, {:required=> attribute[:required_flag].eql?('Y')? true : false},:multiple=>true
        else
          return form.text_field attribute[:attribute_name].to_sym,:required=> attribute[:required_flag].eql?('Y')? true : false
      end

    end
  end

  def show_input_custom_fields(model, columns = 4, &block)
    #获取自定义字段
    custom_attributes = model.custom_attributes

    block_fields = {}
    if block_given?
      builder = CustomFieldBuilder.new(&block)
      yield builder
      block_fields = builder.fields
    end
    build_html(model, custom_attributes, columns, block_fields)
  end

  def build_html(model, custom_attributes, columns = 4, block_fields)
    column_count = 0
    html = ''
    if custom_attributes.any?
      fields_for model, nil, :builder => CustomFormBuilder do |f|
        html += "<tr>"
        custom_attributes.each do |attribute|
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

              if column_count % colspan < colspan
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
            html += "<td class='label-col'><label>#{attribute[:name]}</label></td>"
            html += "<td class='data-col'>#{show_custom_field(attribute, f)}</td>"
            column_count += 2
          end
        end
        #将填不满的给补齐
        ((columns - custom_attributes.count * 2 % columns)/2).times do
          html += "<td class='label-col'></td>"
          html += "<td class='data-col'></td>"
        end
        html += "<tr>"
      end
    end
    html.html_safe
  end



  def show_custom_field_info(model, columns = 6)
    #获取出自定义字段
    custom_attributes = model.custom_attributes

    column_count = 0
    html = ''
    if custom_attributes.any?
      html += "<tr>"
      custom_attributes.each do |attribute|
        if column_count > 0 and column_count%columns == 0
          html += "</tr><tr>"
        end
        html += "<td class='label-col'><label>#{attribute[:name]}</label></td>"
        html += "<td class='data-col'>#{model[attribute[:attribute_name].to_sym]}</td>"
        column_count += 2
      end
      #将填不满的给补齐
      ((columns - custom_attributes.count * 2 % columns)/2).times do
        html += "<td class='label-col'></td>"
        html += "<td class='data-col'></td>"
      end
      html += "<tr>"
    end
    html.html_safe
  end

  class CustomFieldBuilder
    attr_accessor :fields

    def initialize
      self.fields = {}
    end

    def custom_field(key, &block)
      self.fields.merge!({key.to_sym => {:block => block}})
    end
  end

end