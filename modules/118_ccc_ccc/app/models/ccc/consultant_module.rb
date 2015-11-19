class Ccc::ConsultantModule < ActiveRecord::Base
  set_table_name :ccc_consultant_modules
  #多语言关系
  attr_accessor :name,:description
  has_many :consultant_modules_tls,:dependent => :destroy
  acts_as_multilingual


  query_extend
  acts_as_customizable

  validates_presence_of :code,:name
  validates_uniqueness_of :code, :scope => :opu_id


  def to_s
    Ccc::ConsultantModule.multilingual.where(:id=>self.id).first[:name]
  end
end
