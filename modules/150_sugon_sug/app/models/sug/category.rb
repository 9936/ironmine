class Sug::Category < ActiveRecord::Base
  set_table_name :sug_categories

  query_extend

  validates_presence_of :name, :code

  belongs_to :parent, :class_name => name, :foreign_key => :parent_id
  has_many :children, :class_name => name, :foreign_key => :parent_id, :dependent => :destroy

  before_save do
    if self.leaf?
      self.leaf_flag = 'Y'
    end
  end

  before_validation do
    unless self.root?
      self.code = self.parent.code
    end
  end

  scope :roots, lambda {
    where("#{self.table_name}.parent_id IS NULL")
  }

  scope :with_leaf, lambda {
     where("#{self.table_name}.leaf_flag ='Y'")
  }

  scope :query_by_code, lambda{|code|
    where("#{self.table_name}.code=?", code)
  }

  def self.list_all
    select_all
  end

  scope :with_leaf, lambda {|code|
    where("#{table_name}.leaf_flag='Y' AND #{table_name}.code=?", code)
  }

  scope :owned_by_skill, lambda {|skill_id|
    joins("JOIN #{Sug::CategorySkill.table_name} sc ON sc.category_id=#{table_name}.id").
        where("sc.skill_id=?", skill_id)
  }

  scope :available_by_skill, lambda {|skill_id|
    where("NOT EXISTS (SELECT * FROM #{Sug::CategorySkill.table_name} sc WHERE sc.category_id = #{table_name}.id AND sc.skill_id = ?)", skill_id)
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