class Skm::Channel < ActiveRecord::Base
  set_table_name :skm_channels

  #多语言关系
  attr_accessor :name, :description
  has_many :channels_tls, :dependent => :destroy
  acts_as_multilingual

  validates_presence_of :channel_code
  query_extend

  has_many :channel_columns, :class_name => 'Skm::ChannelColumn'
  has_many :columns, :through => :channel_columns

  attr_accessor :column_ids, :access_str

  has_many :channel_groups, :class_name => 'Skm::ChannelGroup'
  has_many :groups, :through => :channel_groups

  has_many :channel_approval_people, :class_name => 'Skm::ChannelApprovalPerson', :dependent => :destroy

  has_many :entry_headers

  default_scope { default_filter }


  scope :query_by_person, lambda { |person_id|
    joins("JOIN #{Skm::ChannelsTl.table_name} sctl ON #{table_name}.id=sctl.channel_id").
        where("sctl.language=?", I18n.locale).
        where("EXISTS(SELECT * FROM irm_person_relations_v pr, #{Skm::ChannelGroup.table_name} cgvv WHERE pr.source_type = ? AND pr.person_id = ? AND pr.source_id = cgvv.group_id AND cgvv.channel_id = #{Skm::Channel.table_name}.id AND #{Skm::Channel.table_name}.status_code=?)",
              "IRM__GROUP", person_id, "ENABLED").
        select("#{table_name}.*, sctl.name")
  }

  scope :without_group, lambda { |group_id|
    where("NOT EXISTS(SELECT * FROM #{Skm::ChannelGroup.table_name} cg WHERE cg.group_id = ? AND cg.opu_id = #{table_name}.opu_id AND cg.channel_id = #{table_name}.id)",
          group_id)
  }

  scope :with_group_ids, lambda { |group_ids|
    where("EXISTS(SELECT * FROM #{Skm::ChannelGroup.table_name} cg WHERE cg.group_id IN (?) AND cg.opu_id = #{table_name}.opu_id AND cg.channel_id = #{table_name}.id)", group_ids + [''])
  }

  def get_column_ids
    self.columns.enabled.collect(&:id).join(",")
  end

  def self.lov(origin_scope, params)
    return origin_scope.where("EXISTS(SELECT * FROM
       (
        select people.group_id source_id,'IRM__GROUP' source_type,people.person_id person_id from irm_group_members people
			  union
			  select people.group_id source_id,'IRM__GROUP_EXPLOSION' source_type,people.person_id person_id from irm_group_members people
			 ) pr,#{Skm::ChannelGroup.table_name} cgvv
       WHERE pr.source_type = ? AND pr.person_id = ? AND pr.source_id = cgvv.group_id AND cgvv.channel_id = #{Skm::Channel.view_name}.id AND #{Skm::Channel.view_name}.status_code=?)",
                              "IRM__GROUP", Irm::Person.current.id, "ENABLED")
  end

end