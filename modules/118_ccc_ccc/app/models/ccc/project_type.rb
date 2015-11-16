class Ccc::ProjectType < ActiveRecord::Base
  set_table_name :ccc_project_types
  #多语言关系
  attr_accessor :name,:description
  has_many :project_types_tls,:dependent => :destroy
  acts_as_multilingual


  query_extend
  acts_as_customizable

  validates_presence_of :code
  validates_uniqueness_of :code, :scope => :opu_id


  def to_s
    Ccc::ProjectType.multilingual.where(:id=>self.id).first[:name]
  end
end
