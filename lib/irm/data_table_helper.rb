module Irm
  module DataTableHelper
    extend ActiveSupport::Concern

    def datatable_view(options = {}, &block)
      raise ArgumentError, "Missing block" unless block_given?
      raise ArgumentError, "Missing row count or datas" unless options[:count].present?||options[:datas].present?
      output = ActiveSupport::SafeBuffer.new
      if params[:_scroll]
        options.merge!(:scroll=>params[:_scroll])
      end
      builder = datatable_builder(options, &block)
      yield builder
      output.safe_concat generate_content(builder)
      output
    end

    private

    def datatable_builder(options)
      DataTableBuilder.new(options)
    end

    def generate_content(builder)
      column_options = filter_columns(builder.columns,builder.display_columns)
      datatable_options = builder.options

      column_count = 0

      #==header
      table_header =  ActiveSupport::SafeBuffer.new
      table_header.safe_concat "<thead><tr>"
      column_options.each do |column|
        next if column[:hidden]
        column_count = column_count + 1
        column_options_str = column_options_str(column)
        table_header.safe_concat "<th #{column_options_str} ><div>#{column[:title]}"
        table_header.safe_concat "</div></th>"
      end
      table_header.safe_concat "</tr></thead>"

      #==body
      table_body = ActiveSupport::SafeBuffer.new
      table_body.safe_concat "<tbody>"
      if builder.options[:datas].any?
        builder.options[:datas].each do |data|
          table_body.safe_concat "<tr id='#{data[:id]}' #{row_html_attributes(builder,data)}>"
          column_options.each do |column|
            next if column[:hidden]
            table_body.safe_concat "<td><div>"
            if column[:block].present?
              table_body.safe_concat capture(data,&column[:block])
            else
              if data[column[:key]].present?
                if data[column[:key]].is_a?(Time)
                  table_body.safe_concat  data[column[:key]].strftime('%Y-%m-%d %H:%M:%S')
                elsif data[column[:key]].is_a?(Date)
                  table_body.safe_concat  data[column[:key]].strftime('%Y-%m-%d')
                else
                  table_body.safe_concat (data[column[:key]]||"").to_s
                end
              else
                table_body.safe_concat ""
              end
            end
            table_body.safe_concat "</div></td>"
          end
          table_body.safe_concat "</tr>"
        end
      else
        table_body.safe_concat "<tr class='no-data'><td colspan='#{column_count}'><div>#{t(:label_no_data)}</div></td></tr>"
      end
      table_body.safe_concat "</tbody>"

      output = ActiveSupport::SafeBuffer.new

      if builder.options[:scroll]
        output.safe_concat "<div class='datatable datatable-scroll scroll#{builder.options[:scroll]}'>"
        output.safe_concat "<div class='table-header scroll-header'><table>"
        output.safe_concat "</table></div>"
        output.safe_concat "<div class='table-body include-header'><table count='#{builder.options[:count]}'>"
        output.safe_concat table_header
        output.safe_concat table_body
        output.safe_concat "</table></div>"
        output.safe_concat "</div>"
      else
        output.safe_concat "<div class='datatable'>"
        output.safe_concat "<div class='table-body include-header'><table count='#{builder.options[:count]}'>"
        output.safe_concat table_header
        output.safe_concat table_body
        output.safe_concat "</table></div>"
        output.safe_concat "</div>"
      end
    end

    def column_options_str(column)
      options_str = ["key='#{column[:key]}'","title='#{column[:title]}'"]
      style = ""
      if column[:width].present?
        if column[:width].include?("%")||column[:width].include?("px")
          style << "width:#{column[:width]};"
        else
          style << "width:#{column[:width]}px;"
        end
      end

      options_str << "origin-width='#{column[:width]}' style='#{style}'"  unless style.blank?


      if column[:sortable].present?
        options_str << "sort='true'"
      end

      if column[:searchable].present?
        options_str << "search='true'"
      end


      options_str.join(" ")


    end


    def filter_columns(columns,display_columns)
      if display_columns.present?&&display_columns.is_a?(Array)&&display_columns.any?
        origin_columns = columns
        result_columns = []
        display_columns.each do |dc|
          result_columns << origin_columns[dc.to_sym] if origin_columns[dc.to_sym].present?
        end
        return result_columns
      else
        return columns.values
      end
    end

    def row_html_attributes(builder,data)
      row_config = builder.row_config
      return "" unless row_config.present?
      attribute = ActiveSupport::SafeBuffer.new
      html_options =  row_config[:options][:html] if row_config[:options][:html].present?&&row_config[:options][:html].is_a?(Hash)
      html_options||={}
      attribute.safe_concat tag_options(html_options)||""
      if row_config[:block].present?
        attribute.safe_concat capture(data,&row_config[:block])
      end
      return attribute

    end

  end

  class DataTableBuilder
    attr_accessor :options ,:columns,:display_columns,:row_config

    def initialize(options)
      self.options = options
      self.display_columns = self.options.delete(:columns)
      self.columns = {}
    end

    def column(key,column_options={},&render_block)
      self.columns.merge!({key.to_sym=>column_options.merge!({:key=>key.to_sym,:block=>render_block})})
    end

    def row(options={},&render_block)
      self.row_config = {:options=>options,:block=>render_block}
    end
  end

end

