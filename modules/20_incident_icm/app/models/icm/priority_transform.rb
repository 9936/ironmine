class Icm::PriorityTransform < ActiveRecord::Base
  set_table_name :icm_priority_transforms

  validates_presence_of :urgence_id, :impact_range_id, :priority_id
  validates_uniqueness_of :priority_id, :scope => [:urgence_id, :impact_range_id, :sid]

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}

  scope :with_sid,lambda{|sid|
    where("#{table_name}.sid =?", sid)
  }

  scope :with_global,lambda{
    where("#{table_name}.sid IS NULL")
  }

  scope :with_impact_urgence, lambda{|impact_id, urgence_id|
    where("#{table_name}.impact_range_id=? AND #{table_name}.urgence_id=?",impact_id, urgence_id)
  }

  #恩将事故单的获取其定义的优先级
  def self.query_priority(sid, impact_id, urgence_id)
    transform = self.with_sid(sid).with_impact_urgence(impact_id, urgence_id).first
    unless transform.present?
      transform = self.with_global.with_impact_urgence(impact_id, urgence_id).first
    end
    transform
  end


end
