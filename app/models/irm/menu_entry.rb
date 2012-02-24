class Irm::MenuEntry < ActiveRecord::Base
  set_table_name :irm_menu_entries

  before_validation :prepare_relation,:prepare_multilingual

  attr_accessor :menu_code,:sub_menu_code,:sub_function_group_code

  #多语言关系
  attr_accessor :name,:description
  has_many :menu_entries_tls,:dependent => :destroy
  acts_as_multilingual

  belongs_to :menu

  belongs_to :sub_menu,:class_name => "Irm::Menu",:foreign_key => :sub_menu_id

  belongs_to :function_group,:foreign_key => :sub_function_group_id

  
  # 验证权限编码唯一性
  validates_presence_of :menu_id

  validates_uniqueness_of :sub_menu_id, :scope => :menu_id, :if => Proc.new { |i| i.sub_menu_id.present? }
  validates_uniqueness_of :sub_function_group_id, :scope => :menu_id, :if => Proc.new { |i| i.sub_function_group_id.present? }
  validate :validate_sub_menu_function_group, :message=>:error_irm_menu_entry_permission_sub_menu_at_least_one

  #加入activerecord的通用方法和scope
  query_extend


  def validate_sub_menu_function_group
    self.sub_menu_id.present?||self.sub_function_group_id
  end
  scope :with_sub_menu,lambda{
     joins("LEFT OUTER JOIN irm_menus_vl mv1 on mv1.id=#{table_name}.sub_menu_id and mv1.language='#{I18n.locale}'").
         select("mv1.code sub_menu_code,mv1.name sub_menu_name")
  }
  scope :with_sub_function_group,lambda{
    joins("LEFT OUTER JOIN irm_function_groups_vl fgv1 on fgv1.id=#{table_name}.sub_function_group_id and fgv1.language='#{I18n.locale}'").
        select("fgv1.code sub_function_group_code,fgv1.name sub_function_group_name")
  }

  private
  def prepare_relation
    if self.menu_code.present?
      r_menu =  Irm::Menu.where(:code=>self.menu_code).first
      if(r_menu)
        self.menu_id = r_menu.id
      end
    end
    if self.sub_menu_code.present?
      r_sub_menu =  Irm::Menu.where(:code=>self.sub_menu_code).first
      if(r_sub_menu)
        self.sub_menu_id = r_sub_menu.id
      end
    end
    if self.sub_function_group_code.present?
      r_sub_function_group =  Irm::FunctionGroup.where(:code=>self.sub_function_group_code).first
      if(r_sub_function_group)
        self.sub_function_group_id = r_sub_function_group.id
      end
    end
  end

  def prepare_multilingual
    unless self.name.present?||self.menu_entries_tls.any?
      self.not_auto_mult = true
      if self.sub_menu_id.present?
        r_sub_menu = Irm::Menu.find(self.sub_menu_id)
        r_sub_menu.menus_tls.each do |sml|
          self.menu_entries_tls.build(:name=>sml.name,:description=>sml.description,:language=>sml.language,:source_lang=>sml.source_lang)
        end
      elsif self.sub_function_group_id
        r_sub_function_group = Irm::FunctionGroup.find(self.sub_function_group_id)
        r_sub_function_group.function_groups_tls.each do |sfgl|
          self.menu_entries_tls.build(:name=>sfgl.name,:description=>sfgl.description,:language=>sfgl.language,:source_lang=>sfgl.source_lang)
        end
      end
    end
  end
end


