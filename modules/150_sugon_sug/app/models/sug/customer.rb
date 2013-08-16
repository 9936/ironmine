class Sug::Customer < ActiveRecord::Base
  set_table_name :sug_customers

  attr_accessor :country_id, :province_id, :city_id, :district_id, :details, :level

  validates_presence_of :country_id, :name, :project

  after_save :save_address, :explore_hierarchy

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  scope :with_parent,lambda{
    joins("LEFT OUTER JOIN #{table_name} parent ON #{table_name}.parent_id = parent.id").
        select("parent.name parent_name")
  }

  scope :with_address, lambda{
    joins("JOIN sug_addresses_vl av on #{self.table_name}.id = av.source_id").
        select("av.address_name").
        where("av.source_type=?", "Sug::Customer")
  }



  def address_meaning
    address = Sug::Address.with_address_name.query_by_source(self.id, self.class.to_s).first
    if address.present?
      return address[:address_name]
    else
      return ""
    end
  end

  def self.lov(lov_scope, params)
    if params[:lov_params].present?&&params[:lov_params].is_a?(Hash)&&params[:lov_params][:lktkn].present?
      #根据不同的来源的lov进行特殊的过滤处理
      if "customer_parent".eql?(params[:lov_params][:lktkn])&& params[:lov_params][:customer_id].present?
        lov_scope = lov_scope.where("#{self.table_name}.id !=?", params[:lov_params][:customer_id])
      end
    end
    lov_scope
  end


  def merge_address
    address = Sug::Address.query_by_source(self.id, self.class.to_s).first
    if address.present?
      self.country_id = address.country_id
      self.province_id = address.province_id
      self.city_id = address.city_id
      self.district_id = address.district_id
      self.details = address.details
    end
  end


  private

    def explore_hierarchy
      Sug::CustomerExplosion.explore_hierarchy(self.id, self.parent_id)
    end



    def save_address
      address = Sug::Address.query_by_source(self.id, self.class.to_s).first
      if address.present?
        address.update_attributes({:country_id => self.country_id,
                                   :province_id => self.province_id,
                                   :city_id => self.city_id,
                                   :district_id => self.district_id,
                                   :details => self.details})
      else
        address = Sug::Address.new({:source_id => self.id,
                                    :source_type => self.class.to_s,
                                    :country_id => self.country_id,
                                    :province_id => self.province_id,
                                    :city_id => self.city_id,
                                    :district_id => self.district_id,
                                    :details => self.details})
        address.save
      end
    end

end
