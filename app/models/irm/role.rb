class Irm::Role < ActiveRecord::Base
  set_table_name :irm_roles

  after_save :explore_role_hierarchy

  attr_accessor :level

  #多语言关系
  attr_accessor :name,:description
  has_many :roles_tls,:dependent => :destroy
  acts_as_multilingual


  # 验证权限编码唯一性
  validates_presence_of :code
  validates_uniqueness_of :code,:scope=>[:opu_id], :if => Proc.new { |i| !i.code.blank? }
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.code.blank?}

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :query_by_role_code, lambda {|role_code| where(:code=>role_code)}


  scope :query_by_person,lambda{|person_id|
    joins("JOIN #{Irm::PersonRole.table_name} ON #{Irm::PersonRole.table_name}.role_id = #{table_name}.id").
    where("#{Irm::PersonRole.table_name}.person_id = ?",person_id)
  }

  scope :with_report_to_role,lambda {|language|
    joins("LEFT OUTER JOIN #{Irm::Role.view_name} report_to ON report_to.id = #{table_name}.report_to_role_id AND report_to.language = '#{language}'").
        select("report_to.name report_to_role_name")
  }

  scope :select_all,lambda{select("#{table_name}.*")}

  scope :top_role,lambda{
    where("#{table_name}.report_to_role_id IS NULL OR report_to_role_id=''")
  }

  scope :parentable,lambda{|role_id|
    where("#{table_name}.id!=? AND NOT EXISTS(SELECT 1 FROM #{Irm::RoleExplosion.table_name} WHERE #{Irm::RoleExplosion.table_name}.parent_role_id = ? AND #{Irm::RoleExplosion.table_name}.role_id = #{table_name}.id)",role_id,role_id)
  }


  def self.list_all
    self.multilingual.with_report_to_role(I18n.locale)
  end

  def self.current
    nil
  end

  private
  def explore_role_hierarchy
    Irm::RoleExplosion.explore_hierarchy(self.id,self.report_to_role_id)
  end

end
