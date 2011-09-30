class Irm::GroupExplosion < ActiveRecord::Base
  set_table_name :irm_group_explosions

  validates_presence_of :group_id,:parent_group_id,:direct_parent_group_id

  validates_uniqueness_of :group_id,:scope => [:parent_group_id,:direct_parent_group_id],:if=>Proc.new{|i| i.group_id.present?&&i.parent_group_id.present?&&i.direct_parent_group_id.present?}

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  def self.explore_hierarchy(group_id,parent_group_id)
    # 当前组的父组没有发生变化，则不进行重新计算
    current_parent = self.where(:group_id=>group_id).first
    if (current_parent&&current_parent.direct_parent_group_id&&current_parent.direct_parent_group_id.eql?(parent_group_id))||(!parent_group_id.present?&&current_parent.nil?)
      return
    end

    # 子组
    child_of_groups =  self.where(:parent_group_id => group_id)
    # 原来的父组
    parent_of_groups = self.where(:group_id => group_id)

    # 如果存在父组，则需要解除与父组之间的关系
    # 解除子组的子组 与 以前父组的关系
    parent_of_groups.each do |p_g|
      child_of_groups.each do |c_g|
        self.where(:group_id=>c_g.group_id,:parent_group_id=>p_g.parent_group_id).delete_all
      end
    end
    #解除子组 与 以前父组的关系
    self.where(:group_id=>group_id).delete_all

    if parent_group_id.present?
      # 现在的父组 的 父组
      parent_parent_group_ids = self.where(:group_id=>parent_group_id).collect{|i| i.parent_group_id}
      # 加上直接父组
      parent_parent_group_ids << parent_group_id
      parent_parent_group_ids.each do |p_p_g_id|
        child_of_groups.each do |c_g|
          self.create(:group_id=>c_g.group_id,:direct_parent_group_id=>c_g.direct_parent_group_id,:parent_group_id=>p_p_g_id)
        end
        self.create(:group_id=>group_id,:direct_parent_group_id=>parent_group_id,:parent_group_id=>p_p_g_id)
      end
    end
  end
end
