class Skm::ChannelApprovalPerson < ActiveRecord::Base
  set_table_name :skm_channel_approval_people

  belongs_to :person, :class_name => 'Irm::Person'
  belongs_to :channel, :class_name => 'Skm::Channel'


  scope :approval_people, lambda{|channel_id|
    select("#{table_name}.id, #{table_name}.person_id").
        where("#{table_name}.channel_id=?", channel_id)
  }
end
