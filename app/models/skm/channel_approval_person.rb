class Skm::ChannelApprovalPerson < ActiveRecord::Base
  set_table_name :skm_channel_approval_people

  belongs_to :person, :class_name => 'Irm::Person'
  belongs_to :channel, :class_name => 'Skm::Channel'

  #has_many :entry_approval_people, :class_name => 'Skm::EntryApprovalPerson', :dependent => :destroy

  scope :approval_people, lambda{|channel_id|
    select("#{table_name}.person_id").
        where("#{table_name}.channel_id=?", channel_id)
  }
end
