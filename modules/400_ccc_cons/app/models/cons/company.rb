class Cons::Company < ActiveRecord::Base
  set_table_name :cons_companies
  has_many :customers


  query_extend
  acts_as_customizable

  validates_presence_of :com_name,:com_address,:com_conscientious,:com_conscientious_tel,:com_conscientious_telNo,:com_conscientious_email,:com_connect_type,:com_router

  validates_uniqueness_of :com_conscientious_email, :if => Proc.new { |i| !i.com_conscientious_email.blank? }, :if => :need_uniqueness_email
  validates_format_of :com_conscientious_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,:message=>:email


  def need_uniqueness_email
    true
  end

  scope :with_company_message,lambda{

  }
end
