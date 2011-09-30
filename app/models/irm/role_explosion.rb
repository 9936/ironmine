class Irm::RoleExplosion < ActiveRecord::Base
  set_table_name :irm_role_explosions

  validates_presence_of :role_id,:parent_role_id,:direct_parent_role_id

  validates_uniqueness_of :role_id,:scope => [:parent_role_id,:direct_parent_role_id],:if=>Proc.new{|i| i.role_id.present?&&i.parent_role_id.present?&&i.direct_parent_role_id.present?}

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  def self.explore_hierarchy(role_id,parent_role_id)
    # 当前角色的父角色没有发生变化，则不进行重新计算
    current_parent = self.where(:role_id=>role_id).first
    if (current_parent&&current_parent.direct_parent_role_id&&current_parent.direct_parent_role_id.eql?(parent_role_id))||(!parent_role_id.present?&&current_parent.nil?)
      return
    end

    # 子角色
    child_of_roles =  self.where(:parent_role_id => role_id)
    # 原来的父角色
    parent_of_roles = self.where(:role_id => role_id)

    # 如果存在父角色，则需要解除与父角色之间的关系
    # 解除子角色的子角色 与 以前父角色的关系
    parent_of_roles.each do |p_r|
      child_of_roles.each do |c_r|
        self.where(:role_id=>c_r.role_id,:parent_role_id=>p_r.parent_role_id).delete_all
      end
    end
    #解除子角色 与 以前父角色的关系
    self.where(:role_id=>role_id).delete_all

    if parent_role_id.present?
      # 现在的父角色 的 父角色
      parent_parent_role_ids = self.where(:role_id=>parent_role_id).collect{|i| i.parent_role_id}
      # 加上直接父角色
      parent_parent_role_ids << parent_role_id
      parent_parent_role_ids.each do |p_p_r_id|
        child_of_roles.each do |c_r|
          self.create(:role_id=>c_r.role_id,:direct_parent_role_id=>c_r.direct_parent_role_id,:parent_role_id=>p_p_r_id)
        end
        self.create(:role_id=>role_id,:direct_parent_role_id=>parent_role_id,:parent_role_id=>p_p_r_id)
      end
    end
  end
end
