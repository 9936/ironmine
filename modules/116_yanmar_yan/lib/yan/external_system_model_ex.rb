module Yan::ExternalSystemModelEx
  def self.included(base)
    base.class_eval do
      scope :with_dev_sys, lambda{
          where("#{table_name}.id IN ('000q00092jgjCXqacqteQS' ,'000q00093z3PYc92V4IF72' ,'000q00093z3PYc92VS8hCi' ,'000q00093z3PYc92VlBMoq')")
      }
    end
  end
end