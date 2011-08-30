class Irm::OrganizationExplosion < ActiveRecord::Base
  set_table_name :irm_organization_explosions

  validates_presence_of :organization_id,:parent_org_id,:direct_parent_org_id

  validates_uniqueness_of :organization_id,:scope => [:parent_org_id,:direct_parent_org_id],:if=>Proc.new{|i| i.organization_id.present?&&i.parent_org_id.present?&&i.direct_parent_org_id.present?}


  def self.explore_hierarchy(org_id,parent_org_id)
    # 当前组织的父组织没有发生变化，则不进行重新计算
    current_parent = self.where(:organization_id=>org_id).first
    if (current_parent&&current_parent.direct_parent_org_id&&current_parent.direct_parent_org_id.eql?(parent_org_id))||(!parent_org_id.present?&&current_parent.nil?)
      return
    end

    # 子组织
    child_of_orgs =  self.where(:parent_org_id => org_id)
    # 原来的父组织
    parent_of_orgs = self.where(:organization_id => org_id)

    # 如果存在父组织，则需要解除与父组织之间的关系
    # 解除子组织的子组织 与 以前父组织的关系
    parent_of_orgs.each do |p_o|
      child_of_orgs.each do |c_o|
        self.where(:organization_id=>c_o.organization_id,:parent_org_id=>p_o.id).delete_all
      end
    end
    #解除子组织 与 以前父组织的关系
    self.where(:organization_id=>org_id).delete_all

    if parent_org_id.present?
      # 现在的父组织 的 父组织
      parent_parent_org_ids = self.where(:organization_id=>parent_org_id).collect{|i| i.parent_org_id}
      # 加上直接父组织
      parent_parent_org_ids << parent_org_id
      parent_parent_org_ids.each do |p_p_o_id|
        child_of_orgs.each do |c_o|
          self.create(:organization_id=>c_o.organization_id,:direct_parent_org_id=>c_o.direct_parent_org_id,:parent_org_id=>p_p_o_id)
        end
        self.create(:organization_id=>org_id,:direct_parent_org_id=>parent_org_id,:parent_org_id=>p_p_o_id)
      end
    end
  end
end
