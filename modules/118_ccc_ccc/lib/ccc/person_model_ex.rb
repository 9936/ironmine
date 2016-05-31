module Ccc::PersonModelEx
  def self.included(base)
    base.class_eval do
      #搜索人信息，公司名称，简档
      scope :with_profile_name, lambda {|language|
                                joins("JOIN #{Irm::Organization.view_name} iot ON #{table_name}.organization_id = iot.id AND iot.language = '#{language}'").
                                joins("JOIN #{Irm::Profile.view_name} iov ON #{table_name}.profile_id = iov.id AND iov.language = '#{language}'").
                                select("#{table_name}.first_name,#{table_name}.login_name,#{table_name}.email_address,#{table_name}.bussiness_phone,iot.`name` com_name,iov.name job_name")
                              }

    end

  end
end

