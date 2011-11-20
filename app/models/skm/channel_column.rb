class Skm::ChannelColumn < ActiveRecord::Base
  set_table_name :skm_channel_columns

  belongs_to :channel, :class_name => 'Skm::Channel'
  belongs_to :column, :class_name => 'Skm::Column'
end