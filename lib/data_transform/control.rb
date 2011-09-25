Irm::DataStructDefine.map do |map|

  #=======================================Irm::OperationUnit============================================
  map.entity(Irm::OperationUnit.name) do |entity|
    entity.primary_key   :id                    ,:varchar                          ,:limit=>22,:null=>false
    entity.key           :short_name            ,:varchar                          ,:limit=>30,:null=>true
    entity.reference     :primary_person_id     ,:varchar,Irm::Person.name         ,:limit=>22,:null=>true
    entity.reference     :license_id            ,:varchar,Irm::License.name        ,:limit=>22,:null=>true
    entity.reference     :default_language_code ,:varchar,Irm::Language.name       ,:limit=>22,:null=>true,:ref_condition=>{:language_code=>:value}
    entity.reference     :default_time_zone_code,:varchar,Irm::LookupValue.name    ,:limit=>30,:null=>true,:ref_condition=>{:lookup_type=>"TIMEZONE",:lookup_code=>:value}
    entity.key_reference :opu_id                ,:varchar,Irm::OperationUnit.name  ,:limit=>22,:null=>true
    entity.column        :status_code           ,:varchar                          ,:limit=>30,:null=>true ,:default=>'ENABLED'
    entity.reference     :created_by            ,:varchar,Irm::Person.name         ,:limit=>22,:null=>true
    entity.reference     :updated_by            ,:varchar,Irm::Person.name         ,:limit=>22,:null=>true
  end
  #=======================================Irm::OperationUnitsTl============================================
  map.entity(Irm::OperationUnitsTl.name) do |entity|
    entity.primary_key   :id               ,:varchar                          ,:limit=>22 ,:null=>false
    entity.key_reference :operation_unit_id,:varchar,Irm::OperationUnit.name  ,:limit=>22 ,:null=>false
    entity.column        :name             ,:varchar                          ,:limit=>30 ,:null=>false
    entity.column        :description      ,:varchar                          ,:limit=>150,:null=>true
    entity.key           :language         ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column        :source_lang      ,:varchar                          ,:limit=>30 ,:null=>true
    entity.reference     :opu_id           ,:varchar,Irm::OperationUnit.name  ,:limit=>22 ,:null=>true
    entity.column        :status_code      ,:varchar                          ,:limit=>30 ,:null=>true ,:default=>'ENABLED'
    entity.reference     :created_by       ,:varchar,Irm::Person.name         ,:limit=>22 ,:null=>true
    entity.reference     :updated_by       ,:varchar,Irm::Person.name         ,:limit=>22 ,:null=>true
  end

  map.dependent(Irm::OperationUnit.name,Irm::OperationUnitsTl.name)

  #===================Irm::Person============================
  map.entity(Irm::Person.name) do |entity|
    entity.primary_key :id                          ,:varchar                          ,:limit=>22 ,:null=>false
    entity.reference   :opu_id                      ,:varchar ,Irm::OperationUnit.name ,:limit=>22 ,:null=>false
    entity.reference   :organization_id             ,:varchar ,Irm::Organization.name  ,:limit=>22 ,:null=>true
    entity.reference   :role_id                     ,:varchar ,Irm::Role.name          ,:limit=>22 ,:null=>true
    entity.reference   :profile_id                  ,:varchar ,Irm::Profile.name       ,:limit=>22 ,:null=>true
    entity.column      :title                       ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :first_name                  ,:varchar                          ,:limit=>30 ,:null=>false
    entity.column      :last_name                   ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :full_name_pinyin            ,:varchar                          ,:limit=>60 ,:null=>true
    entity.column      :full_name                   ,:varchar                          ,:limit=>60 ,:null=>true
    entity.column      :job_title                   ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :vip_flag                    ,:varchar                          ,:limit=>1  ,:null=>true ,:default=>'N'
    entity.column      :support_staff_flag          ,:varchar                          ,:limit=>1  ,:null=>true ,:default=>'N'
    entity.column      :assignment_availability_flag,:varchar                          ,:limit=>1  ,:null=>true ,:default=>'N'
    entity.column      :email_address               ,:varchar                          ,:limit=>150,:null=>true
    entity.column      :home_phone                  ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :home_address                ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :mobile_phone                ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :fax_number                  ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :bussiness_phone             ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :region_code                 ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :site_group_code             ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :site_code                   ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :function_group_code         ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :avatar_path                 ,:varchar                          ,:limit=>150,:null=>true
    entity.column      :avatar_file_name            ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :avatar_content_type         ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :avatar_file_size            ,:int                              ,:limit=>11 ,:null=>true
    entity.column      :avatar_updated_at           ,:datetime                                     ,:null=>true
    entity.column      :approve_request_mail        ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :manager                     ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :delegate_approver           ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :last_login_at               ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :type                        ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :language_code               ,:varchar                          ,:limit=>30 ,:null=>true
    entity.reference   :auth_source_id              ,:varchar ,Irm::LdapAuthHeader.name,:limit=>22 ,:null=>true
    entity.column      :hashed_password             ,:varchar                          ,:limit=>60 ,:null=>true
    entity.column      :login_name                  ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :unrestricted_access_flag    ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :notification_lang           ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :notification_flag           ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :capacity_rating             ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :open_tickets                ,:int                              ,:limit=>11 ,:null=>true
    entity.column      :task_capacity_rating        ,:varchar                          ,:limit=>30 ,:null=>true
    entity.column      :open_tasks                  ,:int                              ,:limit=>11 ,:null=>true
    entity.column      :last_assigned_date          ,:datetime                                     ,:null=>true
    entity.column      :locked_until_at             ,:datetime                                     ,:null=>true
    entity.column      :locked_time                 ,:int                              ,:limit=>11 ,:null=>true ,:default=>'0'
    entity.column      :password_updated_at         ,:datetime                                     ,:null=>true
    entity.column      :status_code                 ,:varchar                          ,:limit=>30 ,:null=>true ,:default=>'ENABLED'
    entity.reference   :created_by                  ,:varchar,Irm::Person.name         ,:limit=>22 ,:null=>true
    entity.reference   :updated_by                  ,:varchar,Irm::Person.name         ,:limit=>22 ,:null=>true
    entity.column      :ldap_dn                     ,:varchar                          ,:limit=>200,:null=>true
  end

  #=======================================Irm::Profile============================================
  map.entity(Irm::Profile.name) do |entity|
    entity.primary_key :id          ,:varchar                          ,:limit=>22,:null=>false
    entity.key_reference :opu_id      ,:varchar,Irm::OperationUnit.name  ,:limit=>22,:null=>false
    entity.column        :user_license,:varchar                          ,:limit=>30,:null=>false
    entity.key           :code        ,:varchar                          ,:limit=>30,:null=>false
    entity.column        :status_code ,:varchar                          ,:limit=>30 ,:null=>true ,:default=>'ENABLED'
    entity.reference     :created_by  ,:varchar,Irm::Person.name         ,:limit=>22 ,:null=>true
    entity.reference     :updated_by  ,:varchar,Irm::Person.name         ,:limit=>22 ,:null=>true
  end

  #=======================================Irm::ProfilesTl============================================
  map.entity(Irm::ProfilesTl.name) do |entity|
    entity.primary_key   :id         ,:varchar                           ,:limit=>22 ,:null=>false
    entity.key_reference :opu_id     ,:varchar ,Irm::OperationUnit.name  ,:limit=>22 ,:null=>true
    entity.key_reference :profile_id ,:varchar ,Irm::Profile.name        ,:limit=>22 ,:null=>false
    entity.key           :language   ,:varchar                           ,:limit=>30 ,:null=>false
    entity.column        :name       ,:varchar                           ,:limit=>150,:null=>false
    entity.column        :description,:varchar                           ,:limit=>240,:null=>true
    entity.column        :source_lang,:varchar                           ,:limit=>30 ,:null=>false
    entity.column        :status_code ,:varchar                          ,:limit=>30 ,:null=>true ,:default=>'ENABLED'
    entity.reference     :created_by  ,:varchar,Irm::Person.name         ,:limit=>22 ,:null=>true
    entity.reference     :updated_by  ,:varchar,Irm::Person.name         ,:limit=>22 ,:null=>true
  end
  map.dependent(Irm::Profile.name,Irm::ProfilesTl.name)

  #=======================================Irm::Organization============================================
  map.entity(Irm::Organization.name) do |entity|
    entity.primary_key   :id           ,:varchar                           ,:limit=>22 ,:null=>false
    entity.reference     :opu_id       ,:varchar ,Irm::OperationUnit.name  ,:limit=>22 ,:null=>true
    entity.reference     :parent_org_id,:varchar ,Irm::Organization.name   ,:limit=>22 ,:null=>true
    entity.key           :short_name   ,:varchar                           ,:limit=>30 ,:null=>false
    entity.column        :status_code  ,:varchar                           ,:limit=>30 ,:null=>true ,:default=>'ENABLED'
    entity.reference     :created_by   ,:varchar,Irm::Person.name          ,:limit=>22 ,:null=>true
    entity.reference     :updated_by   ,:varchar,Irm::Person.name          ,:limit=>22 ,:null=>true
  end

  #=======================================Irm::OrganizationsTl============================================
  map.entity(Irm::OrganizationsTl.name,Irm::Organization.name) do |entity|
    entity.primary_key   :id             ,:varchar                           ,:limit=>22 ,:null=>false
    entity.key_reference :opu_id         ,:varchar ,Irm::OperationUnit.name  ,:limit=>22 ,:null=>true
    entity.key_reference :organization_id,:varchar ,Irm::Organization.name   ,:limit=>22 ,:null=>true
    entity.key           :language       ,:varchar                           ,:limit=>30 ,:null=>false
    entity.column        :name           ,:varchar                           ,:limit=>150,:null=>false
    entity.column        :description    ,:varchar                           ,:limit=>240,:null=>true
    entity.column        :source_lang    ,:varchar                           ,:limit=>30 ,:null=>false
    entity.column        :status_code    ,:varchar                           ,:limit=>30 ,:null=>true ,:default=>'ENABLED'
    entity.reference     :created_by     ,:varchar,Irm::Person.name          ,:limit=>22 ,:null=>true
    entity.reference     :updated_by     ,:varchar,Irm::Person.name          ,:limit=>22 ,:null=>true
  end

  map.dependent(Irm::Organization.name,Irm::OrganizationsTl.name)

  #=======================================Irm::LookupType============================================
  map.entity(Irm::LookupType.name) do |entity|
    entity.primary_key   :id          ,:varchar                        ,:limit=>22,:null=>false
    entity.reference     :opu_id      ,:varchar,Irm::OperationUnit.name,:limit=>22,:null=>true
    entity.column        :product_id  ,:varchar                        ,:limit=>22,:null=>true
    entity.column        :lookup_level,:varchar                        ,:limit=>30,:null=>false
    entity.key           :lookup_type ,:varchar                        ,:limit=>30,:null=>false
    entity.column        :status_code ,:varchar                        ,:limit=>30,:null=>false
    entity.reference     :created_by  ,:varchar,Irm::Person.name       ,:limit=>22,:null=>true
    entity.reference     :updated_by  ,:varchar,Irm::Person.name       ,:limit=>22,:null=>true
  end
  #=======================================Irm::LookupTypesTl============================================
  map.entity(Irm::LookupTypesTl.name) do |entity|
    entity.primary_key   :id            ,:varchar                        ,:limit=>22 ,:null=>false
    entity.reference     :opu_id        ,:varchar,Irm::OperationUnit.name,:limit=>22 ,:null=>true
    entity.column        :product_id    ,:varchar                        ,:limit=>22 ,:null=>true
    entity.key_reference :lookup_type_id,:varchar,Irm::LookupType.name   ,:limit=>22 ,:null=>true
    entity.column        :meaning       ,:varchar                        ,:limit=>60 ,:null=>false
    entity.column        :description   ,:varchar                        ,:limit=>150,:null=>false
    entity.key           :language      ,:varchar                        ,:limit=>30 ,:null=>false
    entity.column        :source_lang   ,:varchar                        ,:limit=>30 ,:null=>false
    entity.column        :status_code   ,:varchar                        ,:limit=>30 ,:null=>false
    entity.reference     :created_by    ,:varchar,Irm::Person.name       ,:limit=>22 ,:null=>true
    entity.reference     :updated_by    ,:varchar,Irm::Person.name       ,:limit=>22 ,:null=>true
  end
  map.dependent(Irm::LookupType.name,Irm::LookupTypesTl.name,Irm::LookupValue.name)
  #=======================================Irm::LookupValue============================================
  map.entity(Irm::LookupValue.name) do |entity|
    entity.primary_key   :id               ,:varchar                        ,:limit=>22,:null=>false
    entity.reference     :opu_id           ,:varchar,Irm::OperationUnit.name,:limit=>22,:null=>true
    entity.key_reference :lookup_type      ,:varchar,Irm::LookupType.name   ,:limit=>30,:null=>false,:ref_condition=>{:lookup_type=>:value}
    entity.key           :lookup_code      ,:varchar                        ,:limit=>30,:null=>false
    entity.column        :start_date_active,:date                                      ,:null=>true
    entity.column        :end_date_active  ,:date                                      ,:null=>true
    entity.column        :status_code      ,:varchar                        ,:limit=>30,:null=>false
    entity.reference     :created_by       ,:varchar,Irm::Person.name       ,:limit=>22,:null=>true
    entity.reference     :updated_by       ,:varchar,Irm::Person.name       ,:limit=>22,:null=>true
  end
  #=======================================Irm::LookupValuesTl============================================
  map.entity(Irm::LookupValuesTl.name) do |entity|
    entity.primary_key   :id             ,:varchar                        ,:limit=>22 ,:null=>false
    entity.reference     :opu_id         ,:varchar,Irm::OperationUnit.name,:limit=>22 ,:null=>true
    entity.key_reference :lookup_value_id,:varchar,Irm::LookupValue.name  ,:limit=>22 ,:null=>false
    entity.key           :language       ,:varchar                        ,:limit=>30 ,:null=>false
    entity.column        :source_lang    ,:varchar                        ,:limit=>30 ,:null=>false
    entity.column        :meaning        ,:varchar                        ,:limit=>60 ,:null=>false
    entity.column        :description    ,:varchar                        ,:limit=>150,:null=>false
    entity.column        :status_code    ,:varchar                        ,:limit=>30 ,:null=>false
    entity.reference     :created_by     ,:varchar,Irm::Person.name       ,:limit=>22 ,:null=>true
    entity.reference     :updated_by     ,:varchar,Irm::Person.name       ,:limit=>22 ,:null=>true
  end
  map.dependent(Irm::LookupValue.name,Irm::LookupValuesTl.name)
end