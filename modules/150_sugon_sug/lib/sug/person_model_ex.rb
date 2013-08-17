module Sug::PersonModelEx
  def self.included(base)
    base.class_eval do
      has_one :address, :class_name => "Sug::Address", :foreign_key => :source_id, :dependent => :destroy
      accepts_nested_attributes_for :address

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