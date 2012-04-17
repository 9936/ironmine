module Irm
  module DataTableHelper
    extend ActiveSupport::Concern

    def datatable_view(options = {}, &block)
      raise ArgumentError, "Missing block" unless block_given?
      raise ArgumentError, "Missing row count or datas" unless options[:count].present?||options[:datas].present?
      output = ActiveSupport::SafeBuffer.new
      builder = datatable_builder(options, &block)
      output.safe_concat "<div class='datatable'>"
        yield builder
      output.safe_concat generate_content(builder)
      output.safe_concat "</div>"
      output
    end

    private

    def datatable_builder(options)
      DataTableBuilder.new(options)
    end

    def generate_content(builder)
      column_options = filter_columns(builder.columns,builder.display_columns)
      datatable_options = builder.options
      output = ActiveSupport::SafeBuffer.new
      #==datatable
      output.safe_concat "<table count='#{datatable_options[:count]}'>"
      #==header
      output.safe_concat "<thead><tr>"
      column_options.each do |column|
        column_options_str = column_options_str(column)
        output.safe_concat "<th #{column_options_str} ><div>#{column[:title]}"
        output.safe_concat "</div></th>"
      end
      output.safe_concat "</tr></thead>"

      #==body
      output.safe_concat "<tbody>"
      builder.options[:datas].each do |data|
        output.safe_concat "<tr id='#{data[:id]}'>"
        column_options.each do |column|
          output.safe_concat "<td><div>"
          if column[:block].present?
            output.safe_concat capture(data,&column[:block])
          else
            if data[column[:key]].present?
              if data[column[:key]].is_a?(Time)
                output.safe_concat  data[column[:key]].strftime('%Y-%m-%d %H:%M:%S')
              elsif data[column[:key]].is_a?(Date)
                output.safe_concat  data[column[:key]].strftime('%Y-%m-%d')
              else
                output.safe_concat (data[column[:key]]||"").to_s
              end
            else
              output.safe_concat ""
            end
          end
          output.safe_concat "</div></td>"
        end
        output.safe_concat "</tr>"
      end
      output.safe_concat "</tbody>"
      output.safe_concat "</table>"
      output
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

      options_str << "style='#{style}'"  unless style.blank?


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
          result_columns << origin_columns[dc.to_sym]
        end
        return result_columns
      else
        return columns.values
      end
    end

  end

  class DataTableBuilder
    attr_accessor :options ,:columns,:display_columns

    def initialize(options)
      self.options = options
      self.display_columns = self.options.delete(:columns)
      self.columns = {}
    end

    def column(key,column_options={},&render_block)
      self.columns.merge!({key.to_sym=>column_options.merge!({:key=>key.to_sym,:block=>render_block})})
    end
  end

end

