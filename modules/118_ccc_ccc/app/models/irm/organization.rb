class Irm::Organization < ActiveRecord::Base
  set_table_name :irm_organizations

  after_save :explore_org_hierarchy

  attr_accessor :level

  #多语言关系
  attr_accessor :name,:description
  has_many :organizations_tls,:dependent => :destroy
  acts_as_multilingual


  belongs_to :industry
  belongs_to :conn_type

  validates_presence_of :router,:industry_id,:conn_type_id,:address,:conscientious,:conscientious_tel,:conscientious_telNo,:conscientious_email
  validates_uniqueness_of :address,:scope=>[:opu_id], :if => Proc.new { |i| i.address.present? }

  validates_uniqueness_of :conscientious_email, :if => Proc.new { |i| !i.conscientious_email.blank? }, :if => :need_uniqueness_email
  validates_format_of :conscientious_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,:message=>:email


  def need_uniqueness_email
    true
  end

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_parent,lambda{|language|
    joins("LEFT OUTER JOIN #{view_name} parent ON #{table_name}.parent_org_id = parent.id AND parent.language = '#{language}'").
        select("parent.name parent_org_name")
  }

  scope :parentable,lambda{|org_id|
    where("#{table_name}.id!=? AND NOT EXISTS(SELECT 1 FROM #{Irm::OrganizationExplosion.table_name} WHERE #{Irm::OrganizationExplosion.table_name}.parent_org_id = ? AND #{Irm::OrganizationExplosion.table_name}.organization_id = #{table_name}.id)",org_id,org_id)
  }

  scope :with_name,lambda{|language|
                        joins("LEFT OUTER JOIN #{Irm::Organization.view_name} ON #{Irm::Organization.view_name}.id = #{table_name}.organization_id AND #{Irm::Organization.view_name}.language = '#{language}'").
                            select("#{Irm::Organization.view_name}.name name")
                      }

  scope :with_industry,lambda{|language|
                            joins("LEFT OUTER JOIN #{Ccc::Industry.view_name} ON #{Ccc::Industry.view_name}.id = #{table_name}.industry_id AND #{Ccc::Industry.view_name}.language = '#{language}'").
                                select("#{Ccc::Industry.view_name}.name industry_name")
                          }

  scope :with_conn_type,lambda{|language|
                        joins("LEFT OUTER JOIN #{Ccc::ConnType.view_name} ON #{Ccc::ConnType.view_name}.id = #{table_name}.conn_type_id AND #{Ccc::ConnType.view_name}.language = '#{language}'").
                            select("#{Ccc::ConnType.view_name}.name conn_type_name")
                      }

  def self.list_all
    with_industry(I18n.locale).
    with_conn_type(I18n.locale)
  end

  def explore_org_hierarchy
    Irm::OrganizationExplosion.explore_hierarchy(self.id,self.parent_org_id)
  end


end
