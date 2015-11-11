class Cons::Consultants < ActiveRecord::Base
  set_table_name :cons_consultants
  has_many :subordinates, class_name: "Consultants",
           foreign_key: "manager_no"

  belongs_to :manager, class_name: "Consultants"

  attr_accessor :password_confirmation,:password,:login_name,:profile_id,:organization_id,:module

  query_extend
  acts_as_customizable

  # 数据验证
  validates_presence_of :cNo,:cName, :cType, :cSex, :cTel,:cTelNo,:cMail,:password,:password_confirmation,:login_name

  # validates_presence_of :password,:if=> Proc.new{|i| i.hashed_password.blank?&&i.validate_as_person?}
  # validates_confirmation_of :password, :allow_nil => true,:if=> Proc.new{|i|i.hashed_password.blank?||!i.password.blank?}
  # validate :validate_password_policy,:if=> Proc.new{|i| i.password.present?&&i.password_confirmation.present?}

  validates_uniqueness_of :cMail, :if => Proc.new { |i| !i.cMail.blank? }, :if => :need_uniqueness_email
  validates_format_of :cMail, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,:message=>:email

  validates :password, confirmation: true
  validates :password_confirmation, presence: true


  def need_uniqueness_email
    true
  end
  scope :with_consultants_message,lambda{
         # joins("LEFT OUTER JOIN #{Bbs::CategoriesTl.table_name} ip0 ON  ip0.categories_id = #{table_name}.categories_id and ip0.language='zh'").
         # joins("LEFT OUTER JOIN #{Irm::Person.table_name} ip1 ON  ip1.id = #{table_name}.author_id").
         # joins("LEFT OUTER JOIN #{Irm::Person.table_name} ip2 ON  ip2.id = #{table_name}.last_response_by_id").
         # select("#{table_name}.*, cNo cNo, cName cName, cMail cMail")
   }
end


class Cons::TemplatePerson < Cons::Consultants

  # Overrides a few properties
  def logged?; false end
  def real?; false end
  def validate_as_person?;false end
end