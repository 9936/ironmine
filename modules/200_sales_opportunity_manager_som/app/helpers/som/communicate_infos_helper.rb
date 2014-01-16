module Som::CommunicateInfosHelper
  #获取我方参与人员信息
  def our_participation(communicate_id)
    info=""
    ours=Som::ParticipationInfo.where(:communicate_id=>communicate_id,:client_flag=>'N')
    ours.each do |our|
       info<<"#{charge_person_name(our.name)}(#{translate_person_role(our.role)});&nbsp;&nbsp;&nbsp;&nbsp;"
    end
    info
  end

  #获取客户参与人员信息
  def client_participation(communicate_id)
    info=""
    clients=Som::ParticipationInfo.where(:communicate_id=>communicate_id,:client_flag=>'Y')
    clients.each do |client|
      info<<"#{client.name}(#{client.role});&nbsp;&nbsp;&nbsp;&nbsp;"
    end
    info
  end
end
