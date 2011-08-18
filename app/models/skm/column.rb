class Skm::Column < ActiveRecord::Base
  set_table_name :skm_columns

  #多语言关系
  attr_accessor :name,:description, :parent_column_name
  has_many :columns_tls, :class_name => 'Skm::ColumnsTl',:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :column_code
  validates_uniqueness_of :column_code

  query_extend

  has_many :column_accesses

  belongs_to :parent, :class_name => "Skm::Column", :foreign_key => "parent_column_id"

  has_many :children, :class_name => "Skm::Column", :foreign_key => "parent_column_id", :dependent => :destroy

  def is_leaf?
    children = Skm::Column.where(:parent_column_id => self.id)
    !children.any?
  end

  def get_child_nodes(with_check = "")
    child_nodes = []
    children = Skm::Column.multilingual.where(:parent_column_id => self.id)
    children.each do |c|
      is_leaf = c.is_leaf?
      column_accesses = ""
      ca_recs = c.column_accesses.uniq
      ca_recs.each do |ca|
        begin
          column_accesses << I18n.t("label_" + ca.source_type.underscore.gsub("\/","_")) + ":" + ca.source.to_s
        rescue
          column_accesses << ca.source_type + "-" + ca.source_id
        end
        (column_accesses << ", ") unless ca == ca_recs.last
      end
      child_node = {:id=>c.id,:text=>c[:name],:sc_id=>c.id, :sc_code => c.column_code,
                    :column_name => c[:name], :column_description => c[:description],
                    :column_accesses=> column_accesses,
                    :leaf => is_leaf, :checked => false, :children => []}
      child_node[:children] = c.get_child_nodes
      child_node.delete(:children) if child_node[:children].size == 0
      child_node.delete(:checked) unless with_check
      child_node[:checked] = true if with_check.present? && with_check.split(",").include?(c.id.to_s)

      child_nodes << child_node
    end

    child_nodes
  end

  #当前人员可访问的栏目
  def self.current_person_accessible_columns(person=Irm::Person.current)
    all_root_columns = Skm::Column.enabled.where("LENGTH(parent_column_id) = 0")
    accessible_ids = []
    all_root_columns.each do |ac|
      accessible_ids << ac.recursive_check_accessible(false, person)
    end
    accessible_ids.flatten()
  end

  def recursive_check_accessible(parent_accessible=false,person=Irm::Person.current)
    accessible_ids = []
    ac_flag = false
    column_accesses = self.column_accesses
    ac_flag = parent_accessible unless column_accesses.any?
    column_accesses.each do |ca|
      ac_flag = ca.current_person_accessible?(person)
      break if ac_flag
    end
    accessible_ids << self.id if ac_flag

    self.children.each do |cc|
      accessible_ids << cc.recursive_check_accessible(ac_flag)
    end

    accessible_ids
  end
end