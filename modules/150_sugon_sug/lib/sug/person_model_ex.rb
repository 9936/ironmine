module Sug::PersonModelEx
  def self.included(base)
    base.class_eval do
      attr_accessor :country_id, :province_id, :city_id, :district_id, :details

      validates_presence_of :country_id

      after_find do
        address = Sug::Address.query_by_source(self.id, self.class.to_s).first
        if address.present?
          self.country_id = address.country_id
          self.province_id = address.province_id
          self.city_id = address.city_id
          self.district_id = address.district_id
          self.details = address.details
        end
      end

      after_save do
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

      def address_meaning
        address = Sug::Address.with_address_name.query_by_source(self.id, self.class.to_s).first
        if address.present?
          return address[:address_name]
        else
          return ""
        end
      end
    end
  end
end