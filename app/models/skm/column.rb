class Skm::Column < ActiveRecord::Base
  set_table_name :skm_columns

  #多语言关系
  attr_accessor :name,:description
  has_many :columns_tls, :class_name => 'Skm::ColumnsTl',:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :column_code
  validates_uniqueness_of :column_code

  def is_leaf?
    children = Skm::Column.where(:parent_column_id => self.id)
    !children.any?
  end

  def get_child_nodes
    child_nodes = []
    children = Skm::Column.multilingual.where(:parent_column_id => self.id)
    children.each do |c|
      is_leaf = c.is_leaf?
      child_node = {:id=>c.id,:text=>c[:name],:sc_id=>c.id,:column_name=>c[:name], :leaf => is_leaf, :children => []}
      child_node[:children] = c.get_child_nodes
      child_node.delete(:children) if child_node[:children].size == 0

      child_nodes << child_node
    end

    child_nodes
  end
end