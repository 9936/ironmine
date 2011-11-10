require 'spreadsheet'
class Array
  def to_xls(columns,options={})
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => options[:sheet_name]||"Sheet1"

    if block_given?
      yield sheet
    end

    append_to_xls_sheet(sheet,columns,options)

    report = StringIO.new
    book.write(report)
    report.string
  end

  def append_to_xls_sheet(sheet,columns,options={})

    if options[:title].present?
      row_count = sheet.row_count
      title_format = Spreadsheet::Format.new(:color => :black,:weight => :bold)
      if options[:title_format]&&options[:title_format].is_a?(Hash)
        title_format = Spreadsheet::Format.new({:color => :black,:weight => :bold}.merge(options[:title_format]))
      end
      sheet.row(row_count).default_format = title_format
      sheet.row(row_count).push(options[:title])
    end

    if columns.any?
      # 向excel中输出表头信息
      row_count = sheet.row_count

      formats = {}

      if columns&&columns.is_a?(Array)
        columns.each { |column|
          unless options[:header_hidden]
            # 设置表头excel格式
            header_format = Spreadsheet::Format.new(:color => :black,:weight => :bold)
            if options[:header_format]&&options[:header_format].is_a?(Hash)
              header_format = Spreadsheet::Format.new({:color => :black,:weight => :bold}.merge(options[:header_format]))
            end

            sheet.row(row_count).default_format = header_format
            sheet.row(row_count).push column[:label]
          end
          formats.merge(column[:key].to_sym,Spreadsheet::Format.new(column[:format])) if column[:format]&&column[:format].is_a?(Hash)
        }
      end


      # 向表格中输出数据信息
      self.each do |item|
        couples = {}
        couples = item.attributes.symbolize_keys if item.attributes
        row_count = sheet.row_count

        # 如果对单独的一行数据有格式要求,则对这行的数据格式进行设置
        if couples[:row_format]&&couples[:row_format].is_a?(Hash)
          sheet.row(row_count).default_format = Spreadsheet::Format.new(couples[:row_format])
        end

        columns.each_with_index do |column,index|
          # 设置每一列的格式
          unless couples[:row_format]&&couples[:row_format].is_a?(Hash)
            sheet.row(row_count).set_format(formats[column[:key].to_sym],index) if formats[column[:key].to_sym]
          end
          value = nil
          value = item.send(column[:key].to_sym) if item.respond_to?(column[:key].to_sym)
          value ||= couples[column[:key].to_sym]
          if(value.is_a? Time)
            value = value.strftime('%Y-%m-%d %H:%M:%S')
          end
          sheet.row(row_count).push value
        end
      end
    end
  end

  #将数组转化为Hash，方便将hash输出为excel
  def to_cus_hash
    arr_hash = {}
    self.each_index do |index|
      arr_hash.merge!({index.to_s.to_sym=>self[index]})    
    end
    arr_hash
  end
end

class Hash
  #使用to_xls识别hash
  def attributes
    self
  end

  def self.recursive_symbolize_keys(hash)
    return unless hash.is_a?(Hash)
    hash.values.each do |v|
      next unless v.is_a?(Hash)
      recursive_symbolize_keys(v)
    end
    hash.symbolize_keys!
  end

  def self.recursive_stringify_keys(hash)
    return unless hash.is_a?(Hash)
    hash.values.each do |v|
      next unless v.is_a?(Hash)
      recursive_stringify_keys(v)
    end
    hash.stringify_keys!
  end
end
