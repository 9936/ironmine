class Skm::ChannelsTl < ActiveRecord::Base
  set_table_name :skm_channels_tl

  belongs_to :channel
  validates_presence_of :name
end