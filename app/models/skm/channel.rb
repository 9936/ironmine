class Skm::Channel < ActiveRecord::Base
  set_table_name :skm_channels

  #多语言关系
  attr_accessor :name,:description
  has_many :channels_tls,:dependent => :destroy
  acts_as_multilingual

  validates_presence_of :channel_code
  query_extend

  has_many :channel_columns, :class_name => 'Skm::ChannelColumn'
  has_many :columns, :through => :channel_columns

  attr_accessor :column_ids, :access_str

  has_many :channel_groups, :class_name => 'Skm::ChannelGroup'
  has_many :groups, :through => :channel_groups

  scope :without_group, lambda{|group_id|
      where("NOT EXISTS(SELECT * FROM #{Skm::ChannelGroup.table_name} cg WHERE cg.group_id = ? AND cg.opu_id = #{table_name}.opu_id AND cg.channel_id = #{table_name}.id)",
            group_id)
  }
  def get_column_ids
    self.columns.enabled.collect(&:id).join(",")
  end
end