class Irm::LookupValue < ActiveRecord::Base
  set_table_name :irm_lookup_values

  before_create :build_sequence

  has_many :lookup_values_tls,:class_name =>"Irm::LookupValuesTl",:foreign_key=>"lookup_value_id",:dependent => :destroy

  attr_accessor :meaning,:description
  #如果语言表里面字段不是name和description的话，需要特别指出
  acts_as_multilingual({:columns =>[:meaning,:description],:required=>[:meaning]})

  query_extend

  #验证lookup_code在lookup_type下面的唯一性
  validates :start_date_active,:lookup_code,:presence => true
  validates_uniqueness_of :lookup_code,:scope=>[:opu_id,:lookup_type]

  scope :query_by_lookup_type,lambda{|lookup_type|where(:lookup_type=>lookup_type)}
  scope :query_by_lookup_code,lambda{|lookup_code|where(:lookup_code=>lookup_code)}

  scope :order_by_sequence,lambda{
    self.order("sequence ASC")
  }

  scope :query_wrap_info,lambda{|language|
    select("#{table_name}.*,v1.meaning,v1.description, v1.meaning status_meaning").
        joins(",#{Irm::LookupValuesTl.table_name} v1").
        where("v1.lookup_value_id = #{table_name}.id AND v1.language=?",language)}

  def self.check_lookup_code_exist(lookup_type,lookup_code)
     exist_lookup_code=Irm::LookupValue.query_by_lookup_code(lookup_code).
          query_by_lookup_type(lookup_type)
      if Irm::LookupValue.query_by_lookup_code(lookup_code).
          query_by_lookup_type(lookup_type).size>0
         return false,exist_lookup_code.id
      else
         return true,0
      end

  end

  def self.check_lookup_code(lookup_type,lookup_code)
      if Irm::LookupValue.query_by_lookup_code(lookup_code).
          query_by_lookup_type(lookup_type).size>0
         return false
      else
         return true
      end
  end

  def wrap_meaning
    self[:meaning]
  end

  def self.get_meaning(lookup_type, lookup_code)
    Irm::LookupValue.multilingual.query_by_lookup_type(lookup_type).where(:lookup_code => lookup_code).first[:meaning]
  rescue
    ""
  end

  def self.get_code_id(lookup_type, lookup_code)
    Irm::LookupValue.query_by_lookup_type(lookup_type).where(:lookup_code => lookup_code).first.id
  end

  def self.get_lookup_value(lookup_type)
    Irm::LookupValue.multilingual.order_by_sequence.query_by_lookup_type(lookup_type)
  end

  #前一value
  def pre_value
    pre_value = Irm::LookupValue.query_by_lookup_type(self.lookup_type).where("sequence < ?", self.sequence).order("sequence DESC").first
    if pre_value.present?
      pre_value
    else
      self
    end
  end

  #后一value
  def next_value
    next_value = Irm::LookupValue.query_by_lookup_type(self.lookup_type).where("sequence > ?",self.sequence).order("sequence ASC").first
    if next_value.present?
      next_value
    else
      self
    end
  end

  private
    #构建sequence
    def build_sequence
      current_sequence = Irm::LookupValue.select("sequence").where("lookup_type=?",self.lookup_type).order("sequence DESC").first
      if current_sequence.present?
        self.sequence = current_sequence[:sequence] + 1
      else
        self.sequence = 1
      end
    end
end
