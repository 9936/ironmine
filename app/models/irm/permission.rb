class Irm::Permission < ActiveRecord::Base
  set_table_name :irm_permissions

  #多语言关系
  attr_accessor :name,:description
  has_many :permissions_tls,:dependent => :destroy
  acts_as_multilingual

  # 验证权限编码唯一性
  validates_presence_of :permission_code,:page_controller,:page_action
  validates_uniqueness_of :permission_code, :if => Proc.new { |i| !i.permission_code.blank? }
  validates_format_of :permission_code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.permission_code.blank?}

  #加入activerecord的通用方法和scope
  query_extend

  #通过controller,action确定permission
  scope :position,lambda {|controller,action| where("page_controller = ? AND page_action = ?", controller,action) }

  #查找人员的权限
  scope :query_by_person,lambda{|person_id|
    joins("LEFT OUTER JOIN #{Irm::FunctionMember.table_name} ON #{Irm::FunctionMember.table_name}.permission_code = #{table_name}.permission_code").
    joins("LEFT OUTER JOIN #{Irm::FunctionGroupMember.table_name} ON #{Irm::FunctionGroupMember.table_name}.function_code = #{Irm::FunctionMember.table_name}.function_code").
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} ON #{Irm::Person.table_name}.function_group_code = #{Irm::FunctionGroupMember.table_name}.group_code").
    where("#{Irm::Person.table_name}.id = ?",person_id)
  }
  # 登陆即可访问的权限
  scope :logined,lambda{
    joins("LEFT OUTER JOIN #{Irm::FunctionMember.table_name} ON #{Irm::FunctionMember.table_name}.permission_code = #{table_name}.permission_code").
    where("#{Irm::FunctionMember.table_name}.function_code = 'LOGINED_FUNCTION'")
  }

  # 无需登陆即可访问的权限
  scope :publiced,lambda{
    joins("LEFT OUTER JOIN #{Irm::FunctionMember.table_name} ON #{Irm::FunctionMember.table_name}.permission_code = #{table_name}.permission_code").
    where("#{Irm::FunctionMember.table_name}.function_code = 'PUBLIC_FUNCTION'")
  }
  # 判断是否为公开权限
  # //TODO 使用缓存
  def publiced?
    self.class.publiced.collect{|p| p.permission_code}.include?(self.permission_code)
  end
  # 判断是否登录即可访问的权限
  # //TODO 使用缓存
  def logined?
    self.class.logined.collect{|p| p.permission_code}.include?(self.permission_code)
  end

  def self.url_key(controller,action)
    "#{controller.gsub(/\//, "_")}_#{action}"
  end

  def self.to_permission(options={})
    Irm::Permission.new(options)
  end

end
