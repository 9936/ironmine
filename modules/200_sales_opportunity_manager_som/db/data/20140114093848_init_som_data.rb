# -*- coding: utf-8 -*-
class InitSomData < ActiveRecord::Migration
  def up
    require 'spreadsheet'
    Irm::Person.current = Irm::Person.where(:login_name=>"ironmine").first
    I18n.locale = "zh"
    book = Spreadsheet::open(File.expand_path(File.join(File.dirname(__FILE__), '..', 'files','init_data.xls')))
    sheet1 = book.worksheet 0
    sheet1.each do |row|
      m = {}
      m[:charge_person] = row[0]
      if Irm::Person.where(:full_name=>m[:charge_person]).first.present?
        m[:charge_person] = Irm::Person.where(:full_name=>m[:charge_person]).first.id
      end
      m[:name] = row[1]
      m[:content] = row[2]
      m[:potential_customer] = row[3]
      if Som::PotentialCustomer.where(:full_name=>m[:potential_customer]).first.present?
        m[:potential_customer] = Som::PotentialCustomer.where(:full_name=>m[:potential_customer]).first.id
      end
      m[:region] = row[4]
      if Irm::LookupValue.multilingual.where(:lookup_type=>"SOM_REGION_INFO").where("meaning=?",m[:region]).first.present?
        m[:region] = Irm::LookupValue.multilingual.where(:lookup_type=>"SOM_REGION_INFO").where("meaning=?",m[:region]).first.lookup_code
      end
      m[:address] = row[5]
      m[:price_year] = row[6]
      m[:price] = row[7]
      m[:total_price]  = row[8]
      m[:open_at]  = row[9].to_s
      if m[:open_at].include?(".")
        m[:open_at] = Date.new(m[:open_at].split(".")[0].to_i,m[:open_at].split(".")[1].to_i==0?1:m[:open_at].split(".")[1].to_i,1)
      else
        m[:open_at] = Date.new(m[:open_at].to_i,1,1)
      end
      m[:previous_flag] = row[10]
      if m[:previous_flag].eql?("是")
        m[:previous_flag] = "Y"
      else
        m[:previous_flag] = "N"
      end
      m[:sales_status] = row[11]
      if Irm::LookupValue.multilingual.where(:lookup_type=>"SOM_PRODUCTION_STATUS").where("meaning=?",m[:sales_status]).first.present?
        m[:sales_status] = Irm::LookupValue.multilingual.where(:lookup_type=>"SOM_PRODUCTION_STATUS").where("meaning=?",m[:sales_status]).first.lookup_code
      end
      m[:possibility] = row[12]
      m[:possibility] = m[:possibility].to_f*100
      m[:involved_production_info]=[]
      m[:involved_production_info] << "OPERATION" if row[13].present?
      m[:involved_production_info] << "HISMS" if row[14].present?
      m[:involved_production_info] << "EBS" if row[15].present?
      m[:involved_production_info] << "SIEBEL" if row[16].present?
      m[:involved_production_info] << "HR/PEOPLESOFT" if row[17].present?
      m[:involved_production_info] << "HYPERION" if row[18].present?
      m[:involved_production_info] << "MS" if row[19].present?
      m[:involved_production_info] << "JAVA" if row[20].present?
      m[:involved_production_info].join(",")
      m[:sales_person] = row[21]

      if Irm::Person.where(:full_name=>m[:sales_person]).first.present?
        m[:sales_person] = Irm::Person.where(:full_name=>m[:sales_person]).first.id
      else
        m[:sales_person] = m[:charge_person]
      end
      m[:internal_member] = row[22].to_s
      m[:external_member] = row[23].to_s
      sale = Som::SalesOpportunity.new(m)
      sale.total_price = 0 unless sale.total_price.present?
      sale.price = 0 unless sale.price.present?
      if sale.total_price.to_f - sale.price.to_f >0
        sale.start_at = Date.new(2013,1,1)
        sale.end_at = Date.new(2014,12,31)
      else
        sale.start_at = Date.new(2013,1,1)
        sale.end_at = Date.new(2014,12,31)
      end


      sale.save
      puts sale.errors.to_a.to_s
    end


  end

  def down
  end
end
