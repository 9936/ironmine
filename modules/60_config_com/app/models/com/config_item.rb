class Com::ConfigItem < ActiveRecord::Base
  set_table_name :com_config_items
  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}
  has_many :config_item_attributes,:dependent => :destroy
  validates_presence_of :item_number,:config_class_id
  validates_uniqueness_of :item_number,:scope=>[:opu_id], :if => Proc.new { |i| !i.item_number.blank? }
  before_save :default_values

  def default_values
    self.last_checked_at ||= Time.now
  end

  scope :with_config_class,lambda{

    joins("LEFT OUTER JOIN #{Com::ConfigClass.view_name} ON #{table_name}.config_class_id=#{Com::ConfigClass.view_name}.id and #{Com::ConfigClass.view_name}.language='#{I18n.locale}'").
        select("#{Com::ConfigClass.view_name}.name config_class_name")
  }

  scope :available, lambda{|config_item_id|
     joins("JOIN #{Com::ConfigItemRelation.table_name} cir ON #{table_name}.id =cir.config_item_id").
         where("cir.id !=? AND #{table_name}.id !=?", config_item_id, config_item_id)
  }

  scope :with_managed_group,lambda{
    if Ironmine::Application.config.fwk.modules.include?("slm")
      joins("LEFT OUTER JOIN #{Icm::SupportGroup.multilingual_view_name} ON #{table_name}.managed_group_id=#{Icm::SupportGroup.multilingual_view_name}.id and #{Icm::SupportGroup.multilingual_view_name}.language='#{I18n.locale}'").
          select("#{Icm::SupportGroup.multilingual_view_name}.name managed_group_name")
    else
      scoped
    end
  }
  scope :with_managed_person,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} ON #{table_name}.managed_person_id=#{Irm::Person.table_name}.id").
        select("#{Irm::Person.table_name}.full_name managed_person_name")
  }

  def relation_items
    Com::ConfigItem.joins("JOIN #{Com::ConfigItemRelation.table_name} cir ON #{Com::ConfigItem.table_name}.id=cir.relation_config_item_id").
        joins("JOIN #{Com::ConfigRelationTypesTl.table_name} crtl ON crtl.config_relation_type_id=cir.config_relation_type_id").
        select("#{Com::ConfigItem.table_name}.*, crtl.name relation_type_name").
        where("cir.config_item_id=? AND crtl.language=?", self.id, I18n.locale)
  end

  def parent_nodes
    items = []
    parents = Com::ConfigItem.joins("JOIN #{Com::ConfigItemRelation.table_name} cir ON #{Com::ConfigItem.table_name}.id=cir.config_item_id").
        where("cir.relation_config_item_id=?", self.id)
    if parents.any?
      parents.each do |item|
        items << item
        items += item.parent_nodes
      end
    end
    items.uniq
  end

end
