# -*- coding: utf-8 -*-
class IronmineOpuData < ActiveRecord::Migration
  def self.up
    enterprise = Irm::License.new(:code=>'ENTERPRISE',:not_auto_mult=>true)
    enterprise.licenses_tls.build(:language=>'zh',:source_lang=>'en',:name=>'企业',:description=>'企业')
    enterprise.licenses_tls.build(:language=>'en',:source_lang=>'en',:name=>'Enterprise',:description=>'Enterprise')

    Irm::Function.all.each do |f|
      enterprise.license_functions.build(:function_id=>f.id)
    end

    enterprise.save

    opu = Irm::OperationUnit.first
    opu.update_attributes(:license_id=>enterprise.id,:not_auto_mult=>true)

    organization = Irm::Organization.new(:short_name=>'ORG',:not_auto_mult=>true)
    organization.organizations_tls.build(:language=>'zh',:source_lang=>'en',:name=>'组织',:description=>'组织')
    organization.organizations_tls.build(:language=>'en',:source_lang=>'en',:name=>'Organization',:description=>'Organization')

    organization.save

    profile = Irm::Profile.new(:code=>'HELP_DESK',:user_license=>"SUPPORTER",:not_auto_mult=>true)
    profile.profiles_tls.build(:language=>'zh',:source_lang=>'en',:name=>'服务台人',:description=>'服务台人员')
    profile.profiles_tls.build(:language=>'en',:source_lang=>'en',:name=>'Help Desk',:description=>'Help Desk')
    profile.save

    person=Irm::Person.create(:first_name=>"ironmine",:login_name=>"ironmine",:email_address=>"ironmine@hand-china.com",:hashed_password=>Irm::Person.hash_password("aaaa1111"),:profile_id=>profile.id,:organization_id=>organization.id)

    opu.update_attributes(:primary_person_id=>person.id,:not_auto_mult=>true)

    Irm::Person.where("LENGTH(id)<?",22).delete_all
    Irm::ObjectCode.update_all(:opu_id=>opu.id,:created_by=>Irm::Person.anonymous.id,:updated_by=>Irm::Person.anonymous.id)
    Irm::MachineCode.update_all(:opu_id=>opu.id,:created_by=>Irm::Person.anonymous.id,:updated_by=>Irm::Person.anonymous.id)

    Irm::Person.current = person

    #Irm::SystemParameter
    login_page_logo = Irm::SystemParameter.new(:parameter_code=>'LOGIN_PAGE_LOGO',
                                               :content_type=>'GLOBAL_SETTING',
                                               :data_type=>'IMAGE',
                                               :value => "Y",
                                               :status_code=>'ENABLED',
                                               :not_auto_mult=>true)
    login_page_logo.system_parameters_tls.build(:system_parameter_id=>login_page_logo.id,
                                               :name=>'登陆页面LOGO',
                                               :description=>'登陆页面LOGO',
                                               :language=>'zh',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    login_page_logo.system_parameters_tls.build(:system_parameter_id=>login_page_logo.id,
                                               :name=>'Login page logo',
                                               :description=>'Login page logo',
                                               :language=>'en',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    login_page_logo.save

    app_top_logo = Irm::SystemParameter.new(:parameter_code=>'APP_TOP_LOGO',
                                               :content_type=>'GLOBAL_SETTING',
                                               :data_type=>'IMAGE',
                                               :value => "Y",
                                               :status_code=>'ENABLED',
                                               :not_auto_mult=>true)
    app_top_logo.system_parameters_tls.build(:system_parameter_id=>app_top_logo.id,
                                               :name=>'应用顶部LOGO',
                                               :description=>'应用顶部LOGO',
                                               :language=>'zh',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    app_top_logo.system_parameters_tls.build(:system_parameter_id=>app_top_logo.id,
                                               :name=>'Logo on page top',
                                               :description=>'Logo on page top',
                                               :language=>'en',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    app_top_logo.save

    address_logo = Irm::SystemParameter.new(:parameter_code=>'ADDRESS_BAR_LOGO',
                                               :content_type=>'GLOBAL_SETTING',
                                               :data_type=>'IMAGE',
                                               :value => "Y",
                                               :status_code=>'ENABLED',
                                               :not_auto_mult=>true)
    address_logo.system_parameters_tls.build(:system_parameter_id=>address_logo.id,
                                               :name=>'地址栏LOGO',
                                               :description=>'地址栏LOGO',
                                               :language=>'zh',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    address_logo.system_parameters_tls.build(:system_parameter_id=>address_logo.id,
                                               :name=>'Address bar logo',
                                               :description=>'Address bar logo',
                                               :language=>'en',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    address_logo.save

    app_title = Irm::SystemParameter.new(:parameter_code=>'APPLICATION_TITLE',
                                               :content_type=>'GLOBAL_SETTING',
                                               :data_type=>'TEXT',
                                               :value => "Ironmine",
                                               :status_code=>'ENABLED',
                                               :not_auto_mult=>true)
    app_title.system_parameters_tls.build(:system_parameter_id=>app_title.id,
                                               :name=>'应用标题',
                                               :description=>'应用标题',
                                               :language=>'zh',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    app_title.system_parameters_tls.build(:system_parameter_id=>app_title.id,
                                               :name=>'Application title',
                                               :description=>'Application title',
                                               :language=>'en',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    app_title.save

    host_name = Irm::SystemParameter.new(:parameter_code=>'HOST_NAME',
                                               :content_type=>'GLOBAL_SETTING',
                                               :data_type=>'TEXT',
                                               :value => "IRONMINE_SERVER",
                                               :status_code=>'ENABLED',
                                               :not_auto_mult=>true)
    host_name.system_parameters_tls.build(:system_parameter_id=>host_name.id,
                                               :name=>'主机名',
                                               :description=>'主机名',
                                               :language=>'zh',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    host_name.system_parameters_tls.build(:system_parameter_id=>host_name.id,
                                               :name=>'Host name',
                                               :description=>'Host name',
                                               :language=>'en',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    host_name.save

    host_path = Irm::SystemParameter.new(:parameter_code=>'HOST_PATH',
                                               :content_type=>'GLOBAL_SETTING',
                                               :data_type=>'TEXT',
                                               :value => "",
                                               :status_code=>'ENABLED',
                                               :not_auto_mult=>true)
    host_path.system_parameters_tls.build(:system_parameter_id=>host_path.id,
                                               :name=>'主机地址',
                                               :description=>'主机地址',
                                               :language=>'zh',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    host_path.system_parameters_tls.build(:system_parameter_id=>host_path.id,
                                               :name=>'Host path',
                                               :description=>'Host path',
                                               :language=>'en',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    host_path.save

    emission_email_address = Irm::SystemParameter.new(:parameter_code=>'EMISSION_EMAIL_ADDRESS',
                                               :content_type=>'GLOBAL_SETTING',
                                               :data_type=>'TEXT',
                                               :value => "ironmine.root@gmail.com",
                                               :status_code=>'ENABLED',
                                               :not_auto_mult=>true)
    emission_email_address.system_parameters_tls.build(:system_parameter_id=>emission_email_address.id,
                                               :name=>'系统邮件发件人地址',
                                               :description=>'系统邮件发件人地址',
                                               :language=>'zh',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    emission_email_address.system_parameters_tls.build(:system_parameter_id=>emission_email_address.id,
                                               :name=>'Emission email address',
                                               :description=>'Emission email address',
                                               :language=>'en',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    emission_email_address.save

    time_zone = Irm::SystemParameter.new(:parameter_code=>'TIMEZONE',
                                               :content_type=>'GLOBAL_SETTING',
                                               :data_type=>'SELECT',
                                               :value => 'GMT_P0800_6',
                                               :status_code=>'ENABLED',
                                               :not_auto_mult=>true)
    time_zone.system_parameters_tls.build(:system_parameter_id=>time_zone.id,
                                               :name=>'时区',
                                               :description=>'时区',
                                               :language=>'zh',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    time_zone.system_parameters_tls.build(:system_parameter_id=>time_zone.id,
                                               :name=>'Timezone',
                                               :description=>'Timezone',
                                               :language=>'en',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    time_zone.save

    upload_file_limit = Irm::SystemParameter.new(:parameter_code=>'UPLOAD_FILE_LIMIT',
                                               :content_type=>'GLOBAL_SETTING',
                                               :data_type=>'NUMBER',
                                               :value => '10000',
                                               :status_code=>'ENABLED',
                                               :not_auto_mult=>true)
    upload_file_limit.system_parameters_tls.build(:system_parameter_id=>upload_file_limit.id,
                                               :name=>'上传文件大小限制(KB)',
                                               :description=>'上传文件大小限制(KB)',
                                               :language=>'zh',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    upload_file_limit.system_parameters_tls.build(:system_parameter_id=>upload_file_limit.id,
                                               :name=>'Upload file limit(KB)',
                                               :description=>'Upload file limit(KB)',
                                               :language=>'en',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    upload_file_limit.save

    host_port = Irm::SystemParameter.new(:parameter_code=>'HOST_PORT',
                                               :content_type=>'GLOBAL_SETTING',
                                               :data_type=>'TEXT',
                                               :value => "3000",
                                               :status_code=>'ENABLED',
                                               :not_auto_mult=>true)
    host_port.system_parameters_tls.build(:system_parameter_id=>host_port.id,
                                               :name=>'主机端口',
                                               :description=>'主机端口',
                                               :language=>'zh',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    host_port.system_parameters_tls.build(:system_parameter_id=>host_port.id,
                                               :name=>'Host port',
                                               :description=>'Host port',
                                               :language=>'en',
                                               :status_code=>'ENABLED',
                                               :source_lang=>'en')
    host_port.save

    p1 = Irm::SystemParameter.new(:parameter_code => "SKM_SIDEBAR_NAVI_DISPLAY", :value => "Y", :content_type => "SKM_SETTING", :data_type => "SELECT",:status_code=>'ENABLED',:not_auto_mult=>true)
    p1.system_parameters_tls.build(:system_parameter_id => p1.id, :name => "是否显示边栏导航", :description => "是否显示边栏导航", :language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    p1.system_parameters_tls.build(:system_parameter_id => p1.id, :name => "Display Sidebar Navigator", :description => "Display Sidebar Navigator", :language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    p1.save

    p2 = Irm::SystemParameter.new(:parameter_code => "SKM_SIDEBAR_FILE_LINK_DISPLAY", :value => "Y", :content_type => "SKM_SETTING", :data_type => "SELECT",:status_code=>'ENABLED',:not_auto_mult=>true)
    p2.system_parameters_tls.build(:system_parameter_id => p1.id, :name => "边栏导航是否显示文件管理", :description => "边栏导航是否显示文件管理", :language=>'zh',:status_code=>'ENABLED',:source_lang=>'en')
    p2.system_parameters_tls.build(:system_parameter_id => p1.id, :name => "Files Menu in Sidebar Navigator", :description => "Files Menu in Sidebar Navigator", :language=>'en',:status_code=>'ENABLED',:source_lang=>'en')
    p2.save

    #language
    en_language=Irm::Language.new(:language_code=>'zh',
                                     :installed_flag=>'Y',
                                     :not_auto_mult=>true)
    en_language.languages_tls.build(:language_id=>en_language.id,
                                    :description=>"Chinese",
                                    :language=>"en",
                                    :source_lang=>"en")
    en_language.languages_tls.build(:language_id=>en_language.id,
                            :description=>"中文",
                            :language=>"zh",
                            :source_lang=>"en")
    zh_language=Irm::Language.new(:language_code=>'en',
                                     :installed_flag=>'Y',
                                     :not_auto_mult=>true)
    zh_language.languages_tls.build(:language_id=>zh_language.id,
                            :description=>"English",
                            :language=>"en",
                            :source_lang=>"en")
    zh_language.languages_tls.build(:language_id=>zh_language.id,
                            :description=>"英文",
                            :language=>"zh",
                            :source_lang=>"en")
    jp_language=Irm::Language.new(:language_code=>'jp',
                                     :installed_flag=>'N',
                                     :not_auto_mult=>true)
    jp_language.languages_tls.build(:language_id=>zh_language.id,
                            :description=>"Japanese",
                            :language=>"en",
                            :source_lang=>"en")
    jp_language.languages_tls.build(:language_id=>zh_language.id,
                            :description=>"日语",
                            :language=>"zh",
                            :source_lang=>"en")

    en_language.save
    zh_language.save
    jp_language.save

    template_en = Skm::EntryTemplate.new(:entry_template_code => "ENTRY_FROM_ICM_REQUEST_EN",:name=>"Entry From Incident Request",:description=>"Entry From Incident Request")
    template_cn = Skm::EntryTemplate.new(:entry_template_code => "ENTRY_FROM_ICM_REQUEST_ZH",:name=>"从事故单创建的知识库",:description=>"从事故单创建的知识库")
    template_en.save
    template_cn.save

    element_en_1 = Skm::EntryTemplateElement.new(:entry_template_element_code=>"INCIDENT_REQUEST_INFO_EN", :name=>"Request Info",:description=>"Request Info",:default_rows=>"3")
    element_en_2 = Skm::EntryTemplateElement.new(:entry_template_element_code=>"INCIDENT_REQUEST_INSTANCE_EN",:name=>"Instance",:description=>"Instance",:default_rows=>"3")
    element_en_3 = Skm::EntryTemplateElement.new(:entry_template_element_code=>"INCIDENT_REQUEST_SOLUTION_EN",:name=>"Solution",:description=>"Solution",:default_rows=>"6")

    element_cn_1 = Skm::EntryTemplateElement.new(:entry_template_element_code=>"INCIDENT_REQUEST_INFO_ZH", :name=>"事故内容",:description=>"事故内容",:default_rows=>"3")
    element_cn_2 = Skm::EntryTemplateElement.new(:entry_template_element_code=>"INCIDENT_REQUEST_INSTANCE_ZH",:name=>"案例",:description=>"案例",:default_rows=>"3")
    element_cn_3 = Skm::EntryTemplateElement.new(:entry_template_element_code=>"INCIDENT_REQUEST_SOLUTION_ZH",:name=>"解决方案",:description=>"解决方案",:default_rows=>"6")

    element_en_1.save
    element_en_2.save
    element_en_3.save

    element_cn_1.save
    element_cn_2.save
    element_cn_3.save

    en_details_1 = Skm::EntryTemplateDetail.new(:entry_template_id=>template_en.id,
                                                :entry_template_element_id=>element_en_1.id,
                                                :line_num=>1,
                                                :required_flag=>"Y",
                                                :default_rows=>3,
                                                :status_code=>"ENABLED")
    en_details_2 = Skm::EntryTemplateDetail.new(:entry_template_id=>template_en.id,
                                                :entry_template_element_id=>element_en_2.id,
                                                :line_num=>2,
                                                :required_flag=>"N",
                                                :default_rows=>3,
                                                :status_code=>"ENABLED")
    en_details_3 = Skm::EntryTemplateDetail.new(:entry_template_id=>template_en.id,
                                                :entry_template_element_id=>element_en_3.id,
                                                :line_num=>3,
                                                :required_flag=>"N",
                                                :default_rows=>6,
                                                :status_code=>"ENABLED")

    cn_details_1 = Skm::EntryTemplateDetail.new(:entry_template_id=>template_cn.id,
                                                :entry_template_element_id=>element_cn_1.id,
                                                :line_num=>1,
                                                :required_flag=>"Y",
                                                :default_rows=>3,
                                                :status_code=>"ENABLED")
    cn_details_2 = Skm::EntryTemplateDetail.new(:entry_template_id=>template_cn.id,
                                                :entry_template_element_id=>element_cn_2.id,
                                                :line_num=>2,
                                                :required_flag=>"N",
                                                :default_rows=>3,
                                                :status_code=>"ENABLED")
    cn_details_3 = Skm::EntryTemplateDetail.new(:entry_template_id=>template_cn.id,
                                                :entry_template_element_id=>element_cn_3.id,
                                                :line_num=>3,
                                                :required_flag=>"N",
                                                :default_rows=>6,
                                                :status_code=>"ENABLED")

    en_details_1.save
    en_details_2.save
    en_details_3.save
    cn_details_1.save
    cn_details_2.save
    cn_details_3.save

    irm_card_1 = Irm::Card.new(:card_code => "IR_WAITING_MY_REPLY",
                               :background_color => "#ebb4de",
                               :bo_code => "ICM_INCIDENT_REQUESTS",
                               :system_flag => Irm::Constant::SYS_YES,
                               :card_url => "/incident_requests/{{id}}/journals/new",
                               :title_attribute_name => "title",
                               :description_attribute_name => "summary",
                               :date_attribute_name => "updated_at",
                               :status_code => Irm::Constant::ENABLED,:not_auto_mult=>true)
    irm_card_1.cards_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待我回复',:description=>'等待我回复(客户)')
    irm_card_1.cards_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting my reply',:description=>'Waiting my reply(Customer)')
    irm_card_1.save

    irm_card_2 = Irm::Card.new(:card_code => "IR_WAITING_MY_SOLUTION",
                               :background_color => "#ebb4de",
                               :bo_code => "ICM_INCIDENT_REQUESTS",
                               :system_flag => Irm::Constant::SYS_YES,
                               :card_url => "/incident_requests/{{id}}/journals/new",
                               :title_attribute_name => "title",
                               :description_attribute_name => "summary",
                               :date_attribute_name => "updated_at",
                               :status_code => Irm::Constant::ENABLED,:not_auto_mult=>true)
    irm_card_2.cards_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待我解决',:description=>'等待我解决(服务台)')
    irm_card_2.cards_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting my solution',:description=>'Waiting my solution(Help desk)')
    irm_card_2.save

    irm_card_3 = Irm::Card.new(:card_code => "IR_WAITING_HELPDESK_REPLY",
                               :background_color => "#ebb4de",
                               :bo_code => "ICM_INCIDENT_REQUESTS",
                               :system_flag => Irm::Constant::SYS_YES,
                               :card_url => "/incident_requests/{{id}}/journals/new",
                               :title_attribute_name => "title",
                               :description_attribute_name => "summary",
                               :date_attribute_name => "updated_at",
                               :status_code => Irm::Constant::ENABLED,:not_auto_mult=>true)
    irm_card_3.cards_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待服务台回复',:description=>'等待服务台回复(用户)')
    irm_card_3.cards_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting help desk reply',:description=>'Waiting help desk reply(Customer)')
    irm_card_3.save

    irm_card_4 = Irm::Card.new(:card_code => "IR_WAITING_CUSTOMER_REPLY",
                               :background_color => "#ebb4de",
                               :bo_code => "ICM_INCIDENT_REQUESTS",
                               :system_flag => Irm::Constant::SYS_YES,
                               :card_url => "/incident_requests/{{id}}/journals/new",
                               :title_attribute_name => "title",
                               :description_attribute_name => "summary",
                               :date_attribute_name => "updated_at",
                               :status_code => Irm::Constant::ENABLED,:not_auto_mult=>true)
    irm_card_4.cards_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待客户回复',:description=>'等待客户回复(服务台)')
    irm_card_4.cards_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting customer reply',:description=>'Waiting customer reply(Help desk)')
    irm_card_4.save

    irm_card_5 = Irm::Card.new(:card_code => "IR_MY_ALL",
                               :background_color => "#ebb4de",
                               :bo_code => "ICM_INCIDENT_REQUESTS",
                               :system_flag => Irm::Constant::SYS_YES,
                               :card_url => "/incident_requests/{{id}}/journals/new",
                               :title_attribute_name => "title",
                               :description_attribute_name => "summary",
                               :date_attribute_name => "updated_at",
                               :status_code => Irm::Constant::ENABLED,:not_auto_mult=>true)
    irm_card_5.cards_tls.build(:language=>'zh',:source_lang=>'en',:name=>'我所有的事故单',:description=>'我所有的事故单')
    irm_card_5.cards_tls.build(:language=>'en',:source_lang=>'en',:name=>'All my requests',:description=>'All my requests')
    irm_card_5.save

    irm_card_6 = Irm::Card.new(:card_code => "IR_MY_RELATION",
                               :background_color => "#ebb4de",
                               :bo_code => "ICM_INCIDENT_REQUESTS",
                               :system_flag => Irm::Constant::SYS_YES,
                               :card_url => "/incident_requests/{{id}}/journals/new",
                               :title_attribute_name => "title",
                               :description_attribute_name => "summary",
                               :date_attribute_name => "updated_at",
                               :status_code => Irm::Constant::ENABLED,:not_auto_mult=>true)
    irm_card_6.cards_tls.build(:language=>'zh',:source_lang=>'en',:name=>'与我相关的',:description=>'与我相关的')
    irm_card_6.cards_tls.build(:language=>'en',:source_lang=>'en',:name=>'All my relations',:description=>'All my relations')
    irm_card_6.save


    irm_lane_1 = Irm::Lane.new(:lane_code => "IR_WAITING_MY_REPLY",
                               :status_code => Irm::Constant::ENABLED,
                               :not_auto_mult=>true)
    irm_lane_1.lanes_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待我回复',:description=>'等待我回复(客户)')
    irm_lane_1.lanes_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting my reply',:description=>'Waiting my reply(Customer)')
    irm_lane_1.save

    irm_lane_2 = Irm::Lane.new(:lane_code => "IR_WAITING_MY_SOLUTION",
                               :status_code => Irm::Constant::ENABLED,
                               :not_auto_mult=>true)
    irm_lane_2.lanes_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待我解决',:description=>'等待我解决(服务台)')
    irm_lane_2.lanes_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting my solution',:description=>'Waiting my solution(Help desk)')
    irm_lane_2.save

    irm_lane_3 = Irm::Lane.new(:lane_code => "IR_WAITING_HELPDESK_REPLY",
                               :status_code => Irm::Constant::ENABLED,
                               :not_auto_mult=>true)
    irm_lane_3.lanes_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待服务台回复',:description=>'等待服务台回复(用户)')
    irm_lane_3.lanes_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting help desk reply',:description=>'Waiting help desk reply(Customer)')
    irm_lane_3.save

    irm_lane_4 = Irm::Lane.new(:lane_code => "IR_WAITING_CUSTOMER_REPLY",
                               :status_code => Irm::Constant::ENABLED,
                               :not_auto_mult=>true)
    irm_lane_4.lanes_tls.build(:language=>'zh',:source_lang=>'en',:name=>'等待客户回复',:description=>'等待客户回复(服务台)')
    irm_lane_4.lanes_tls.build(:language=>'en',:source_lang=>'en',:name=>'Waiting customer reply',:description=>'Waiting customer reply(Help desk)')
    irm_lane_4.save

    irm_lane_5 = Irm::Lane.new(:lane_code => "IR_MY_ALL",
                               :status_code => Irm::Constant::ENABLED,
                               :not_auto_mult=>true)
    irm_lane_5.lanes_tls.build(:language=>'zh',:source_lang=>'en',:name=>'我所有的事故单',:description=>'我所有的事故单')
    irm_lane_5.lanes_tls.build(:language=>'en',:source_lang=>'en',:name=>'All my requests',:description=>'All my requests')
    irm_lane_5.save

    irm_lane_6 = Irm::Lane.new(:lane_code => "IR_MY_RELATION",
                               :status_code => Irm::Constant::ENABLED,
                               :not_auto_mult=>true)
    irm_lane_6.lanes_tls.build(:language=>'zh',:source_lang=>'en',:name=>'与我相关的',:description=>'与我相关的')
    irm_lane_6.lanes_tls.build(:language=>'en',:source_lang=>'en',:name=>'All my relations',:description=>'All my relations')
    irm_lane_6.save




  end

  def self.down
  end
end
