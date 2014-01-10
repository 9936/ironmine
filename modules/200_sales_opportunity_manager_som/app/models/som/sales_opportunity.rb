class Som::SalesOpportunity < ActiveRecord::Base
  set_table_name 'som_sales_opportunities'
  validates_presence_of :charge_person, :name, :potential_customer, :sales_status, :sales_person, :start_at, :end_at, :price
  validates_numericality_of :price
  attr_accessor :communicate_count, :last_communicate
  has_many :communicate_infos
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  before_save :validate_before_save

  ##负责
  #scope :as_charge_person, lambda {
  #  where("#{table_name}.charge_person=?", Irm::Person.current.id)
  #}
  #
  ##参与
  #scope :as_part_person, lambda {
  #  where("#{table_name}.id in (?)", query_parted_sales+[""])
  #}
  #
  ##无关
  #scope :as_other_person, lambda {
  #  where("#{table_name}.charge_person!=? and #{table_name}.id not in (?)", Irm::Person.current.id, ["#"]+query_parted_sales+[""])
  #}


  scope :as_person_role, lambda { |role_filters,current_person_id|
    where("#{Som::SalesOpportunity.filter_condition(role_filters,current_person_id)}")
  }

  def self.filter_condition(role_filters,current_person_id)
    where_or=[]
    role_filters.each do |role_filter|
      case role_filter
        when "charge"
          where_or << "#{table_name}.charge_person='#{current_person_id}'"
        when "participation"
            where_or << "#{table_name}.id in (select sales.id from #{Som::ParticipationInfo.table_name} participation LEFT OUTER JOIN #{Som::CommunicateInfo.table_name} communicate ON communicate.id = participation.communicate_id LEFT OUTER JOIN #{table_name} sales ON sales.id = communicate.sales_opportunity_id where participation.name='#{current_person_id}')"
        else
            where_or << "#{table_name}.charge_person!='#{current_person_id}' and #{table_name}.id not in (select sales.id from #{Som::ParticipationInfo.table_name} participation LEFT OUTER JOIN #{Som::CommunicateInfo.table_name} communicate ON communicate.id = participation.communicate_id LEFT OUTER JOIN #{table_name} sales ON sales.id = communicate.sales_opportunity_id where participation.name='#{current_person_id}')"
      end
    end
    where=""
    where_or.each_with_index do |d, index|
      if index==where_or.size-1
        where<<d
      else
        where<<d+" or "
      end
    end
    where
  end

  #参与过的预销售
  #def self.query_parted_sales
  #  communicate_ids=Som::ParticipationInfo.where(:name => Irm::Person.current.id).collect(&:communicate_id)
  #  sales_opportunity_ids=[]
  #  communicate_ids.each do |id|
  #    sales_opportunity_ids<<Som::CommunicateInfo.find(id).sales_opportunity_id
  #  end
  #  sales_opportunity_ids
  #end


  scope :as_status, lambda { |status_filters|
    where("#{table_name}.sales_status IN (?)" ,status_filters.split(",") )
  }

  scope :with_charger, lambda {
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} charged ON  charged.id = #{table_name}.charge_person").
        select("charged.full_name charge_person_name")
  }

  scope :with_customer, lambda {
    joins("LEFT OUTER JOIN #{Som::PotentialCustomer.table_name} customer ON  customer.id = #{table_name}.potential_customer").
        select("customer.full_name potential_customer_name")
  }


  scope :with_sales, lambda {
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} sales ON  sales.id = #{table_name}.sales_person").
        select("sales.full_name sales_person_name")
  }

   scope :with_status,lambda{|language|
     joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} sale_status ON sale_status.lookup_type='SOM_PRODUCTION_STATUS' AND sale_status.lookup_code = #{table_name}.sales_status AND sale_status.language= '#{language}'").
         select(" sale_status.meaning sales_status_meaning")
   }


   scope :with_region,lambda{|language|
     joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} region ON region.lookup_type='SOM_REGION_INFO' AND region.lookup_code = #{table_name}.region AND region.language= '#{language}'").
         select(" region.meaning region_meaning")
   }


   def self.list_all
     select_all.with_charger.with_customer.with_sales.with_status(I18n.locale).with_region(I18n.locale)
   end


  def validate_before_save
    self.price_year = self.start_at.year
    if self.end_at.year - self.start_at.year > 1
      self.end_at = Date.new(self.start_at.year, 12, 31)
      self.second_price_year = self.end_at.year
    elsif self.end_at.year - self.start_at.year == 1
      self.second_price_year = self.end_at.year
    elsif self.end_at.year - self.start_at.year < 1
      self.second_price_year = nil
      self.second_price = 0
    end
  end

end
