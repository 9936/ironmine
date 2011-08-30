class Irm::BuColumn < ActiveRecord::Base
  set_table_name :irm_bu_columns

  #多语言关系
  attr_accessor :name,:description
  has_many :bu_columns_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :bu_column_code
  validates_uniqueness_of :bu_column_code, :scope => :opu_id

  has_many :bulletin_columns
  has_many :bulletins, :through => :bulletin_columns

  query_extend

  def is_leaf?
    children = Irm::BuColumn.where(:parent_column_id => self.id)
    !children.any?
  end

  def get_child_nodes(with_check = "")
    child_nodes = []
    children = Irm::BuColumn.multilingual.where(:parent_column_id => self.id)
    children.each do |c|
      is_leaf = c.is_leaf?
      child_node = {:id=>c.id,:text=>c[:name],:sc_id=>c.id, :sc_code => c.bu_column_code,
                    :column_name => c[:name], :column_description => c[:description],
                    :leaf => is_leaf, :checked => false, :children => []}
      child_node[:children] = c.get_child_nodes(with_check)
      child_node.delete(:children) if child_node[:children].size == 0
      child_node.delete(:checked) if with_check.nil?
      child_node[:checked] = true if with_check.present? && with_check.split(",").include?(c.id.to_s)

      child_nodes << child_node
    end

    child_nodes
  end
end