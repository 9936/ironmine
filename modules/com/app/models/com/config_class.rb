class Com::ConfigClass < ActiveRecord::Base
  set_table_name :com_config_classes
  after_save :explore_config_class_hierarchy

  attr_accessor :level
  #多语言关系
  attr_accessor :name,:description
  has_many :config_classes_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :code

  #加入activerecord的通用方法和scope
  query_extend
  #对运维中心数据进行隔离
  default_scope {default_filter}

  def explore_config_class_hierarchy
    Com::ConfigClassExplosion.explore_hierarchy(self.id,self.parent_id)
  end

  #查找对应的父级分类的名称
  scope :query_parent,lambda{|language|
    joins("LEFT OUTER JOIN #{view_name} parent ON #{table_name}.parent_id = parent.id AND parent.language = '#{language}'").
        select("parent.name parent_name")
  }
  #为EXT树形菜单作数据准备
  def get_child_nodes
      child_nodes = []
      children = Com::ConfigClass.multilingual.where(:parent_id => self.id)  #查询出当前节点的所有子节点
      children.each do |c|
        #构造TREE的基本数据结构
        child_node = {:id=>c.id,:text=>c[:name], :children => [],:expanded => true,:iconCls=>"x-tree-icon-parent"}
        child_node[:children] = c.get_child_nodes #递归取子节点
        child_node.delete(:children) if child_node[:children].size == 0
        child_node[:leaf]=child_node[:children].nil?       #如果没有字节点，就标记为叶子节点
        child_nodes << child_node
      end

      child_nodes
  end
end
