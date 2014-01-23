class Som::CommunicateInfo < ActiveRecord::Base
  set_table_name 'som_communicate_infos'
  belongs_to :sales_opportunity
  has_one :participation_info
  attr_accessor :our_persons, :our_roles, :client_persons, :client_roles

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  scope :desc, order("#{table_name}.created_at DESC")


  def self.send_my_communicate(current_person_id, last_interval)
    datas = []
    #I18n.locale = Irm::Person.current.language_code
    I18n.locale = :zh
    columns = [{:key => :name, :label => I18n.t(:label_som_sales_opportunity_name)},
               {:key => :charge_person_name, :label => I18n.t(:label_som_sales_opportunity_charge_person)},
               {:key => :potential_customer_name, :label => I18n.t(:label_som_sales_opportunity_customer)},
               {:key => :price, :label => I18n.t(:label_som_sales_opportunity_sales_price_with_unit)},
               {:key => :second, :label => I18n.t(:label_som_sales_opportunity_sales_second_price_with_unit)},
               {:key => :start_at, :label => I18n.t(:label_som_sales_opportunity_sales_start_at)},
               {:key => :end_at, :label => I18n.t(:label_som_sales_opportunity_sales_end_at)},
               {:key => :sales_status_meaning, :label => I18n.t(:label_som_sales_opportunity_sales_status)},
               {:key => :possibility, :label => I18n.t(:label_som_sales_opportunity_sales_possibility)},
               {:key => :communicate_count, :label => I18n.t(:label_som_sales_opportunity_communicate_count)},
               {:key => :last_communicate, :label => I18n.t(:label_som_sales_opportunity_communicate_last)},
               {:key => :interval_day, :label => I18n.t(:label_som_sales_opportunity_interval_days)}]
    Som::SalesOpportunity.list_all.own_charge(current_person_id).where("possibility>?",0).each do |data|
      communicate_infos = data.communicate_infos.order("communicate_date desc")
      if communicate_infos.any?
        data[:communicate_count]= communicate_infos.length
        data[:last_communicate]= communicate_infos.first.communicate_date
      else
        data[:communicate_count] = 0
        data[:last_communicate]= data.created_at.to_date

      end
      data[:interval_day] = (Date.today - data[:last_communicate]).to_i
      #if data[:interval_day]>last_interval.to_i
        datas<<data
      #end
    end
    unless datas.blank?
      [datas.to_xls(columns),datas.size]
    end
  end
end
