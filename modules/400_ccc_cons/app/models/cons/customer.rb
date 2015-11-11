class Cons::Customer < ActiveRecord::Base
  set_table_name :cons_customers
  belongs_to :company
  # has_and_belongs_to_many :products

  attr_accessor :password_confirmation,:company,:password,:login_name,:profile_id,:organization_id

  query_extend
  acts_as_customizable

  # 数据验证
  validates_presence_of :customer_name,:customer_tel,:customer_telNo,:password,:password_confirmation,:profile_id,:organization_id,:login_name,:customer_email
  validates_uniqueness_of :customer_email, :if => Proc.new { |i| !i.customer_email.blank? }, :if => :need_uniqueness_email
  validates_format_of :customer_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,:message=>:email

  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  scope :with_customer_message,lambda{
  }

  def need_uniqueness_email
    true
  end

  def companyName
    @company = Cons::Company.where("id = ?",self.company_id).first
    @company.com_name
  end

end
