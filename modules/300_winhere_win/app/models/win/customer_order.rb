require 'roo'

class Win::CustomerOrder < ActiveRecord::Base
  set_table_name :win_customer_orders

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :query_by_batch_number, lambda{|batch_number|
    where("#{table_name}.batch_number =?", batch_number)
  }

  def self.latest_batch(person_id)
    latest_batch_number = nil
    customer_orders = self.where(:created_by => person_id).order("batch_number DESC ").limit(1)
    if customer_orders.present?
      latest_batch_number = customer_orders.first.batch_number
    end
    latest_batch_number
  end

  scope :ordered, lambda {
    order("#{table_name}.success_flag")
  }

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    batch_number = Time.now.to_i
    (2..spreadsheet.last_row).each do |i|
      row = spreadsheet.row(i)
      if row.present?
        customer_order = new(:batch_number => batch_number)
        customer_order.vendor_number = row[0]
        customer_order.purchase_order = row[1]
        customer_order.po_line_number = row[2]
        customer_order.part_number = row[3]
        customer_order.vendor_part_number = row[4]
        customer_order.quantity = row[5]
        customer_order.deliver_date = row[6]
        customer_order.reschedule_due_date = row[7]
        customer_order.po_created_date = row[8]
        customer_order.purchase_price = row[9]
        customer_order.extended_cost = row[10]
        if customer_order.save
          customer_order.check
        end

      end

    end
  end


  #执行检查操作
  def check
    #检查客户order_base是否存在
    order_bases = Win::OrderBase.query_by_cus_yh(self.part_number, self.vendor_part_number)
    if order_bases.present?
      #检查价格是否正确
      order_base = order_bases.first
      per_price = order_base.basic_price
      if per_price.to_f == self.purchase_price.to_f
        #检查总价
        puts "===================#{self.purchase_price * quantity} ================#{self.extended_cost}"
        if (self.purchase_price * quantity).to_f == self.extended_cost
          #执行其他检查
        else
          self.success_flag = 'N'
          self.error_message = I18n.t(:label_win_customer_check_errors_cost)
        end
      else
        self.success_flag = 'N'
        self.error_message = I18n.t(:label_win_customer_check_errors_per_price)
      end

    else
      self.success_flag = 'N'
      self.error_message = I18n.t(:label_win_customer_check_errors_no_orderbase)
    end
    self.save
  end

  private

    def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
        when ".xls" then  Roo::Excel.new(file.path, nil, :ignore)
        when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      end
    end
end
