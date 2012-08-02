class Chm::ChangePriority < ActiveRecord::Base
  set_table_name :chm_change_priorities

  #多语言关系
  attr_accessor :name,:description
  has_many :change_priorities_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :code,:weight_values
  validates_uniqueness_of :code,:scope=>[:opu_id], :if => Proc.new { |i| !i.code.blank? }
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.code.blank?},:message=>:code

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :query_by_weight_value,lambda{|weight_value|
    where("#{table_name}.weight_values = ?",weight_value)
  }


  def self.auto_generate
    max_count = Chm::ChangeImpact.all.size+Chm::ChangeUrgency.all.size
    self.where("weight_values>? OR weight_values<1",max_count-1).delete_all
    self.where("weight_values>?",max_count-1).update_all(:status_code=>"OFFLINE")
    1.upto(max_count-1).each do |i|
      unless self.where(:weight_values=>i).exists?
        self.create(:code=>"GRADE_#{i}",:name=>"Grade #{i}",:description=>"Grade #{i}",:weight_values=>i)
      end
    end
  end
end
