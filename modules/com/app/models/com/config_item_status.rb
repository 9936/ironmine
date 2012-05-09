class Com::ConfigItemStatus < ActiveRecord::Base
  set_table_name :com_config_item_statuses

  after_save :process_default

  #多语言关系
  attr_accessor :name,:description
  has_many :config_item_statuses_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :code
  validates_uniqueness_of :code,:scope=>[:opu_id], :if => Proc.new { |i| !i.code.blank? }
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| i.code.present?},:message=>:code

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  scope :query_by_close_flag,lambda{|flag|
    where("#{table_name}.close_flag = ?" ,flag)
  }

  scope :query_by_default_flag,lambda{|flag|
    where("#{table_name}.default_flag = ?" ,flag)
  }


  def self.default_id
    default = self.where(:default_flag=>Irm::Constant::SYS_YES).first
    if default
      return default.id
    else
      default = self.all.first
      if default
        return default.id
      end
      return nil
    end
  end

  private
  def process_default
    return true unless self.default_flag.eql?(Irm::Constant::SYS_YES)
    self.class.where("default_flag = ? AND id != ?", Irm::Constant::SYS_YES,self.id).update_all(:default_flag=>Irm::Constant::SYS_NO)
  end
end
