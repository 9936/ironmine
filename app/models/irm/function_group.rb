class Irm::FunctionGroup < ActiveRecord::Base
  set_table_name :irm_function_groups

  #多语言关系
  attr_accessor :name,:description
  has_many :function_groups_tls,:dependent => :destroy
  acts_as_multilingual

  has_many :functions,:dependent => :destroy

  has_many :menu_entries,:foreign_key => :sub_function_group_id,:dependent => :destroy

  # 验证编码唯一性
  validates_presence_of :code
  validates_uniqueness_of :code, :if => Proc.new { |i| !i.code.blank? }
  validates_format_of :code,:scope=>[:opu_id], :with => /^[A-Z0-9_]*$/ ,:if=>Proc.new{|i| !i.code.blank?}

  query_extend

  scope :query_by_application_ids,lambda{|application_ids|
    joins("JOIN #{Irm::Tab.table_name} ON #{Irm::Tab.table_name}.function_group_id = #{table_name}.id").
    joins("JOIN #{Irm::ApplicationTab.table_name} ON  #{Irm::ApplicationTab.table_name}.tab_id = #{Irm::Tab.table_name}.id").
    where("#{Irm::ApplicationTab.table_name}.application_id in (?)",application_ids.any? ? application_ids : ["#"]).
    order("#{Irm::ApplicationTab.table_name}.default_flag DESC,#{Irm::ApplicationTab.table_name}.seq_num ")
  }

  scope :query_by_application_id,lambda{|application_id|
    joins("JOIN #{Irm::Tab.table_name} ON #{Irm::Tab.table_name}.function_group_id = #{table_name}.id").
    joins("JOIN #{Irm::ApplicationTab.table_name} ON  #{Irm::ApplicationTab.table_name}.tab_id = #{Irm::Tab.table_name}.id").
    where("#{Irm::ApplicationTab.table_name}.application_id =?",application_id).
    order("#{Irm::ApplicationTab.table_name}.default_flag DESC,#{Irm::ApplicationTab.table_name}.seq_num ")
  }


  scope :query_by_url,lambda{|controller,action|
    joins("JOIN #{Irm::Function.table_name} ON #{Irm::Function.table_name}.function_group_id = #{table_name}.id").
    joins("JOIN #{Irm::Permission.table_name} ON #{Irm::Permission.table_name}.function_id = #{Irm::Function.table_name}.id").
    where("#{Irm::Permission.table_name}.controller = ? AND #{Irm::Permission.table_name}.action = ?",controller,action)
  }

  scope :menu_item,lambda{
    where("EXISTS(SELECT 1 FROM #{Irm::MenuEntry.table_name} WHERE #{Irm::MenuEntry.table_name}.sub_function_group_id = #{table_name}.id)")
  }
  # 能直接使用get方法访问的链接
  scope :visitable,lambda{
    joins("JOIN #{Irm::Permission.table_name} ON #{Irm::Permission.table_name}.controller = #{table_name}.controller AND #{Irm::Permission.table_name}.action = #{table_name}.action ").
    where("#{Irm::Permission.table_name}.params_count = ? AND #{Irm::Permission.table_name}.direct_get_flag = ?",0,Irm::Constant::SYS_YES)
  }

  def self.current
    @current
  end

  def self.current=(function_group)
    @current = function_group
  end
end
