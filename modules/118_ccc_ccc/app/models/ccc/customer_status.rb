class Ccc::CustomerStatus < ActiveRecord::Base
  set_table_name :ccc_customer_statuses
  #多语言关系
  attr_accessor :name,:description
  has_many :customer_statuses_tls,:dependent => :destroy
  acts_as_multilingual


  query_extend
  acts_as_customizable

  validates_presence_of :code,:name
  validates_uniqueness_of :code, :scope => :opu_id


  def to_s
    Ccc::CustomerStatus.multilingual.where(:id=>self.id).first[:name]
  end
end
