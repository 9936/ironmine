require 'roo'

class Win::OrderBase < ActiveRecord::Base
  set_table_name :win_order_bases

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :query_by_cus_yh, lambda{|cus_code, yh_number|
    where("#{table_name}.cus_code =? AND yh_number=?", cus_code, yh_number)
  }


  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    (2..spreadsheet.last_row).each do |i|
      row = spreadsheet.row(i)
      cus_code = row[1]
      yh_number = row[3]

      if cus_code.present? and yh_number.present?
        order_bases = query_by_cus_yh(cus_code, yh_number)
        if order_bases.present?
          order_base = order_bases.first
        else
          order_base = new(:cus_code => cus_code, :yh_number => yh_number)
        end
        order_base.cus_replace_code = row[2]
        order_base.yh_replace_number = row[4]
        order_base.box_per_count = row[5]
        order_base.basic_count = row[6]
        order_base.put_type = row[7]
        order_base.layers_count = row[8]
        order_base.material = row[9]
        order_base.art_type = row[10]
        order_base.bp = row[11]
        order_base.basic_price = row[12]
        order_base.basic_bolt_price = row[13]
        order_base.basic_bp_price = row[14]
        order_base.basic_bolt_bp_price = row[15]
        order_base.bp_per_price = row[16]
        order_base.info_flag = row[17]
        order_base.kba_code = row[18]
        order_base.kba_type = row[19]
        order_base.type_code = row[20]
        order_base.package = row[21]
        order_base.dolt_type = row[22]
        order_base.dolt_number = row[23]
        order_base.dolt_per_price = row[24]
        order_base.dolt_yh_per_price = row[25]
        order_base.dolt_info = row[26]
        order_base.paper_flag = row[27]
        order_base.gan_flag = row[28]
        order_base.paper_judge_flag = row[29]
        order_base.order_suffix = row[30]
        order_base.priority = row[31]
        order_base.priority_change = row[32]
        order_base.save
      end

    end
  end

  private
    def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
        when ".xls" then  Roo::Excel.new(file.path, nil, :ignore)
        when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      end
    end
end
