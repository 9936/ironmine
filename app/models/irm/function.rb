class Irm::Function < ActiveRecord::Base
  set_table_name :irm_functions

  attr_accessor :function_group_code

  belongs_to :function_group
  has_many :permissions

  #多语言关系
  attr_accessor :name,:description
  has_many :functions_tls,:dependent => :destroy
  acts_as_multilingual

  query_extend


  # 验证编码唯一性
  validates_presence_of :code
  validates_uniqueness_of :code, :if => Proc.new { |i| !i.code.blank? }
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.code.blank?}

  before_save :setup_group

  scope :with_function_group,lambda{|language|
    joins("JOIN #{Irm::FunctionGroup.view_name} ON #{Irm::FunctionGroup.view_name}.id = #{table_name}.function_group_id AND #{Irm::FunctionGroup.view_name}.language='#{language}'").
    select("#{Irm::FunctionGroup.view_name}.zone_code,#{Irm::FunctionGroup.view_name}.name function_group_name")
  }

  scope :query_profile,lambda{|profile_id|
    joins("JOIN #{Irm::ProfileFunction.table_name} ON #{Irm::ProfileFunction.table_name}.function_id = #{table_name}.id").
    where("#{Irm::ProfileFunction.table_name}.profile_id = ? ",profile_id)

  }

  private
  def setup_group
    if self.function_group_id.nil?&&self.function_group_code.present?
      code_function_group =  Irm::FunctionGroup.where(:code=>self.function_group_code).first
      if(code_function_group)
        self.function_group_id = code_function_group.id
      end
    end
  end
end
