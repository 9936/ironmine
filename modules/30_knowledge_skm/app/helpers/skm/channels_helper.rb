module Skm::ChannelsHelper
  #查找当前用户所能勾看到的频道
  def current_available_channels
    Skm::Channel.query_by_person(Irm::Person.current.id).collect{|i|[i[:name], i.id]}
  end
end