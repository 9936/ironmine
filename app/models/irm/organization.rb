class Irm::Organization < ActiveRecord::Base
  set_table_name :irm_organizations

  after_save :explore_org_hierarchy

  attr_accessor :level

  #多语言关系
  attr_accessor :name,:description
  has_many :organizations_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :short_name
  validates_uniqueness_of :short_name,:scope=>[:opu_id], :if => Proc.new { |i| !i.short_name.blank? }
  validates_format_of :short_name, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.short_name.blank?}

  #加入activerecord的通用方法和scope
  query_extend

  scope :query_by_short_name,lambda{|short_name|
    where(:short_name=>short_name)
  }

  scope :with_parent,lambda{|language|
    joins("LEFT OUTER JOIN #{view_name} parent ON #{table_name}.parent_org_id = parent.id AND parent.language = '#{language}'").
        select("parent.name parent_org_name")
  }

  scope :parentable,lambda{|org_id|
    where("#{table_name}.id!=? AND NOT EXISTS(SELECT 1 FROM #{Irm::OrganizationExplosion.table_name} WHERE #{Irm::OrganizationExplosion.table_name}.parent_org_id = ? AND #{Irm::OrganizationExplosion.table_name}.organization_id = #{table_name}.id)",org_id,org_id)
  }

  def explore_org_hierarchy
    Irm::OrganizationExplosion.explore_hierarchy(self.id,self.parent_org_id)
  end


end
