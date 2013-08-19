class Sug::Category < ActiveRecord::Base
  set_table_name :sug_categories

  query_extend

  validates_presence_of :name, :code
  validates_uniqueness_of :code

  belongs_to :parent, :class_name => name, :foreign_key => :parent_id
  has_many :children, :class_name => name, :foreign_key => :parent_id, :dependent => :destroy

  scope :roots, lambda {
    where("#{self.table_name}.parent_id IS NULL")
  }

  scope :query_by_code, lambda{|code|
    where("#{self.table_name}.code=?", code)
  }

  def root?
    self.parent_id.nil?
  end

  def leaf?
    self.level == 3
  end

  def level
    get_level
  end


  def get_level(level=0)
    if self.root?
      level
    else
      level += 1
      level = self.parent.get_level(level)
    end
    level
  end


end