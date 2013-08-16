class Sug::CustomerExplosion < ActiveRecord::Base
  set_table_name :sug_customer_exp

  validates_presence_of :customer_id, :parent_id,:direct_parent_id

  validates_uniqueness_of :customer_id,:scope => [:parent_id,:direct_parent_id],:if=>Proc.new{|i| i.customer_id.present?&&i.parent_id.present?&&i.direct_parent_id.present?}

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  def self.explore_hierarchy(customer_id, parent_id)
    # 当前客户的父组织没有发生变化，则不进行重新计算
    current_parent = self.where(:customer_id=>customer_id).first
    if (current_parent && current_parent.direct_parent_id && current_parent.direct_parent_id.eql?(parent_id))||(!parent_id.present?&&current_parent.nil?)
      return
    end

    # 子客户
    child_of_customers =  self.where(:parent_id => customer_id)
    # 原来的父组织
    parent_of_customers = self.where(:customer_id => customer_id)

    # 如果存在父客户，则需要解除与父客户之间的关系
    # 解除子客户的子客户 与 以前父客户的关系
    parent_of_customers.each do |p_o|
      child_of_customers.each do |c_o|
        self.where(:customer_id=> c_o.customer_id,:parent_id=>p_o.parent_id).delete_all
      end
    end
    #解除子 与 以前父的关系
    self.where(:customer_id=>customer_id).delete_all

    if parent_id.present?
      # 现在的父的父
      parent_parent_customer_ids = self.where(:customer_id=>parent_id).collect{|i| i.parent_id}
      # 加上直接父
      parent_parent_customer_ids << parent_id
      parent_parent_customer_ids.each do |p_p_o_id|
        child_of_customers.each do |c_o|
          self.create(:customer_id=>c_o.customer_id, :direct_parent_id=>c_o.direct_parent_id,:parent_id=>p_p_o_id)
        end
        self.create(:customer_id => customer_id,:direct_parent_id=>parent_id,:parent_id=>p_p_o_id)
      end
    end
  end
end