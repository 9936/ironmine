class Skm::ChannelGroup < ActiveRecord::Base
  set_table_name :skm_channel_groups

  belongs_to :group, :class_name => 'Irm::Group'
  belongs_to :channel, :class_name => 'Skm::Channel'
end