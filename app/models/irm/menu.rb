class Irm::Menu < ActiveRecord::Base
  set_table_name :irm_menus

  #多语言关系
  attr_accessor :name,:description
  has_many :menus_tls,:dependent => :destroy
  acts_as_multilingual

  # 菜单子项
  has_many :menu_entries ,:dependent => :destroy
  has_many :as_sub_menu_entries,:class_name => "Irm::MenuEntry",:primary_key => :sub_menu_id,:dependent => :destroy

  # 验证权限编码唯一性
  validates_presence_of :code
  validates_uniqueness_of :code,:scope=>[:opu_id], :if => Proc.new { |i| !i.code.blank? }
  validates_format_of :code, :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.code.blank?}

  #加入activerecord的通用方法和scope
  query_extend

  scope :top_menu,lambda{
    where("NOT EXISTS(SELECT 1 FROM #{Irm::MenuEntry.table_name} WHERE #{Irm::MenuEntry.table_name}.sub_menu_id = #{table_name}.id)")
  }


  def self.root_menu
    self.where(:code=>"TOP_MENU").first
  end

end
