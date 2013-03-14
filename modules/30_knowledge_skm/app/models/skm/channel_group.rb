class Skm::ChannelGroup < ActiveRecord::Base
  set_table_name :skm_channel_groups

  belongs_to :group, :class_name => 'Irm::Group'
  belongs_to :channel, :class_name => 'Skm::Channel'

  scope :query_person_without_group, lambda {|channel_id, group_id|
    select("DISTINCT scap.person_id").
        joins("JOIN #{Irm::GroupMember.table_name} igm ON igm.group_id=#{table_name}.group_id").
        joins("JOIN #{Skm::ChannelApprovalPerson.table_name} scap ON scap.person_id=igm.person_id").
        where("#{table_name}.channel_id=? AND #{table_name}.group_id !=? AND scap.channel_id=?", channel_id, group_id, channel_id)
  }
end