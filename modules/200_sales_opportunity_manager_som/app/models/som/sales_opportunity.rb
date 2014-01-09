class Som::SalesOpportunity < ActiveRecord::Base
   set_table_name 'som_sales_opportunities'
   validates_presence_of :charge_person,:name,:potential_customer,:sales_status,:sales_person,:start_at,:end_at,:price
   validates_numericality_of :price
   attr_accessor :communicate_count,:last_communicate
   has_many :communicate_infos
   #加入activerecord的通用方法和scope
   query_extend
   # 对运维中心数据进行隔离
   default_scope { default_filter }

   before_save :validate_before_save

   #负责
   scope :as_charge_person,lambda{
    where("#{table_name}.charge_person=?",Irm::Person.current.id)
  }

   #参与
   scope :as_part_person,lambda{
     where("#{table_name}.id in (?)",query_parted_sales+[""])
   }

   #无关
   scope :as_other_person,lambda{
     where("#{table_name}.charge_person!=? and #{table_name}.id not in (?)",Irm::Person.current.id,["#"]+query_parted_sales+[""])
   }

   #参与过的预销售
   def self.query_parted_sales
     communicate_ids=Som::ParticipationInfo.where(:name_id=>Irm::Person.current.id).collect(&:communicate_id)
     sales_opportunity_ids=[]
     communicate_ids.each do |id|
       sales_opportunity_ids<<Som::CommunicateInfo.find(id).sales_opportunity_id
     end
     sales_opportunity_ids
   end


   scope :as_quote_status,lambda{
     where("#{table_name}.sales_status='QUOTE'")
   }

   scope :as_project_status,lambda{
     where("#{table_name}.sales_status='PROJECT'")
   }

   scope :as_bid_status,lambda{
     where("#{table_name}.sales_status='BID'")
   }

   scope :as_business_status,lambda{
     where("#{table_name}.sales_status='BUSINESS'")
   }

   scope :as_cancel_status,lambda{
     where("#{table_name}.sales_status='CANCEL'")
   }
   scope :with_charger,lambda{
       joins("LEFT OUTER JOIN #{Irm::Person.table_name} charged ON  charged.id = #{table_name}.charge_person").
           select("charged.full_name charge_person_name")
   }

   scope :with_customer,lambda{
     joins("LEFT OUTER JOIN #{Som::PotentialCustomer.table_name} customer ON  customer.id = #{table_name}.potential_customer").
         select("customer.full_name potential_customer_name")
   }


   scope :with_sales,lambda{
     joins("LEFT OUTER JOIN #{Irm::Person.table_name} sales ON  sales.id = #{table_name}.sales_person").
         select("sales.full_name sales_person_name")
   }


   def self.list_all
     select_all.with_charger.with_customer.with_sales
   end

  def validate_before_save
    self.price_year = self.start_at.year
    if self.end_at.year - self.start_at.year > 1
      self.end_at = Date.new(self.start_at.year,12,31)
      self.second_price_year = self.end_at.year
    elsif self.end_at.year - self.start_at.year == 1
      self.second_price_year = self.end_at.year
    elsif self.end_at.year - self.start_at.year < 1
      self.second_price_year = nil
      self.second_price = nil
    end
  end

end
