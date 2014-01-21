class Som::SalesOpportunity < ActiveRecord::Base
  set_table_name 'som_sales_opportunities'
  validates_presence_of :charge_person, :name, :potential_customer, :sales_status, :sales_person, :start_at, :end_at,:total_price,:price
  validates_numericality_of :total_price,:price
  attr_accessor :communicate_count, :last_communicate,:author_people_str
  has_many :communicate_infos
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope { default_filter }

  has_many :sales_authorizes

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
    where("#{table_name}.sales_status IN (?)" ,status_filters )
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

  scope :own_charge,lambda{|charge_person|
    where("#{table_name}.charge_person= ? ",charge_person)
  }

   def self.list_all
     select_all.with_charger.with_customer.with_sales.with_status(I18n.locale).with_region(I18n.locale)
   end


  def validate_before_save
    if self.total_price.present?&&self.price.present?&&self.total_price.to_i>=self.price.to_i
      self.second_price = self.total_price.to_i-self.price.to_i
    elsif self.total_price.present?&&self.price.present?&&self.total_price.to_i<self.price.to_i
      self.price = self.total_price.to_i
    elsif !self.total_price.present?&&self.price.present?
      self.total_price = self.price
      sefl.second_price = 0
    end
  end

  def create_sales_authorize_from_str
    return unless self.author_people_str
    str_datas = self.author_people_str.delete_if{|i| !i.present?}
    exists_datas = Som::SalesAuthorize.where(:sales_opportunity_id=>self.id)
    exists_datas.each do |data|
      if str_datas.include?(data.person_id)
        str_datas.delete(data.person_id)
      else
        data.destroy
      end
    end

    str_datas.each do |data_str|
      next unless data_str.strip.present?
      self.sales_authorizes.build(:person_id=>data_str)
    end if str_datas.any?

  end

  def get_author_people_str
    return @get_author_people_str if @get_author_people_str
    @get_author_people_str = self.sales_authorizes.collect{|i| i.person_id}.join(",")
    @get_author_people_str
  end




  def self.send_summary_data
    datas = []
    #I18n.locale = Irm::Person.current.language_code
    I18n.locale = :zh
    columns = [{:key => :region_meaning, :label => I18n.t(:label_som_sales_opportunity_region)},
             {:key => :charge_person_name, :label => I18n.t(:label_som_sales_opportunity_charge_person)},
             {:key => :name, :label => I18n.t(:label_som_sales_opportunity_alias_name)},
             {:key => :potential_customer_name, :label => I18n.t(:label_som_sales_opportunity_customer)},
             {:key => :address, :label => I18n.t(:label_som_sales_opportunity_address)},
             {:key => :price_year, :label => I18n.t(:label_som_sales_opportunity_price_year)},
             {:key => :price, :label => I18n.t(:label_som_sales_opportunity_price)},
             {:key => :total_price, :label => I18n.t(:label_som_sales_opportunity_total_price)},
             {:key => :possibility, :label => I18n.t(:label_som_sales_opportunity_sales_alias_possibility)},
             {:key => :sales_person_name, :label => I18n.t(:label_som_sales_opportunity_sales_alias_person)}]

    total_summary = {:region_meaning=>I18n.t(:label_som_sales_opportunity_total_summary),:price=>0,:total_price=>0}
    Som::SalesOpportunity.list_all.where("possibility > ?",99).group_by{|i| i["region_meaning"]}.each do |region_meaning,data_array|
      datas << {}
      summary = {:region_meaning=>"#{I18n.t(:label_som_sales_opportunity_summary)}:#{region_meaning}",:price=>0,:total_price=>0}
      data_array.each_with_index{|sale,index|
        if index==0
          datas << sale.attributes
        else
          datas << sale.attributes.merge("region_meaning"=>"")
        end
        summary[:price] =  summary[:price]+ sale.price.to_f||0
        summary[:total_price] =  summary[:total_price]+ sale.total_price.to_f||0

      }
      datas << summary
      total_summary[:price] =  summary[:price]+ total_summary[:price]
      total_summary[:total_price] =  summary[:total_price]+ total_summary[:total_price]
    end
    datas << total_summary
    datas.to_xls(columns)
  end

end
