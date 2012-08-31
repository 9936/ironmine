class Com::ConfigClassExplosion < ActiveRecord::Base
  set_table_name :com_config_class_explosions

  validates_presence_of :config_class_id,:parent_id,:direct_parent_id

  validates_uniqueness_of :config_class_id,:scope => [:parent_id,:direct_parent_id],:if=>Proc.new{|i| i.config_class_id.present?&&i.parent_id.present?&&i.direct_parent_id.present?}
  #加入activerecord的通用方法和scope
  query_extend
  #对运维中心数据进行隔离
  default_scope {default_filter}

  scope :children_ids,lambda{|config_class_id|
    select(:config_class_id).where(:parent_id => config_class_id)
  }

  def self.explore_hierarchy(id,parent_id)
    #当前配置分类的父组织没有发生变化，则不进行重新计算
    current_parent = self.where(:config_class_id=>id).first
    if (current_parent&&current_parent.direct_parent_id&&current_parent.direct_parent_id.eql?(parent_id))||(!parent_id.present?&&current_parent.nil?)
      return
    end

    #子配置分类
    child_of_config_classes =  self.where(:parent_id => id)
    #原来的父配置分类
    parent_of_config_classes = self.where(:config_class_id => id)

    #如果存在父配置分类，则需要解除与父配置分类之间的关系
    #解除子配置的子配置与以前父配置的关系
    parent_of_config_classes.each do |p_o|
      child_of_config_classes.each do |c_o|
        self.where(:config_class_id=>c_o.config_class_id,:parent_id=>p_o.parent_id).delete_all
      end
    end
    #解除子配置与以前父配置的关系
    self.where(:config_class_id=> id).delete_all

    if parent_id.present?
      #现在的父配置的父配置
      parent_parent_ids = self.where(:config_class_id=>parent_id).collect{|i| i.parent_id}
      #加上直接父配置
      parent_parent_ids << parent_id
      parent_parent_ids.each do |p_p_id|
        child_of_config_classes.each do |c_o|
          self.create(:config_class_id=>c_o.config_class_id,:direct_parent_id=>c_o.direct_parent_id,:parent_id=>p_p_id)
        end
        self.create(:config_class_id=>id,:direct_parent_id=>parent_id,:parent_id=>p_p_id)
      end
    end
  end

end