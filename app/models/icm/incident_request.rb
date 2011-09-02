class Icm::IncidentRequest < ActiveRecord::Base
  set_table_name :icm_incident_requests

  has_many :incident_journals

  validates_presence_of :title,:requested_by,:submitted_by,:impact_range_id,:urgence_id,:priority_id,:request_type_code,:incident_status_id,:report_source_code

  attr_accessor :pass_flag,:close_flag

  validates_presence_of :summary,:message=>I18n.t(:label_icm_incident_journal_message_body_not_blank)


  validates_presence_of :support_group_id,:support_person_id,:if=>Proc.new{|i| !i.pass_flag.nil?&&!i.pass_flag.blank?}

  #加入activerecord的通用方法和scope
  query_extend
  before_save :setup_organization
  after_create :generate_request_number
  before_validation_on_create  :setup_priority


  acts_as_recently_objects(:title => "title",
                           :target_controller => "icm/incident_journals",
                           :target_action => "new",
                           :target_id => "id",
                           :target_id_column => "request_id")

  acts_as_searchable(:direct =>"query_by_request_number",
                     :all=>"search",
                     :show_url  => {:controller=>"icm/incident_journals",:action=>"new",:request_id=>:id})
  acts_as_urlable(:show=>{:controller=>"icm/incident_journals",:action=>"new",:request_id=>:id},:title=>:title)


  # 查询当天新建的事故单，根据数量生成序列号
  scope :created_at_today,lambda{|cid|
    where("#{table_name}.created_at > ? AND #{table_name}.id <= ?",Date.today,cid)
  }
  # 查询出优先级
  scope :with_priority,lambda{|language|
    joins("LEFT OUTER JOIN #{Icm::PriorityCode.view_name} priority_code ON  #{table_name}.priority_id = priority_code.id AND priority_code.language= '#{language}'").
    select(" priority_code.name priority_name")
  }
  # 查询出请求类型
  scope :with_request_type,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} request_type ON request_type.lookup_type='ICM_REQUEST_TYPE_CODE' AND request_type.lookup_code = #{table_name}.request_type_code AND request_type.language= '#{language}'").
    select(" request_type.meaning request_type_name")
  }
  # 查询出服务
  scope :with_service,lambda{|language|
    joins("LEFT OUTER JOIN #{Slm::ServiceCatalog.view_name} service ON service.catalog_code = #{table_name}.service_code AND service.language= '#{language}'").
    select(" service.name service_name")
  }
  # 查询出客户
  scope :with_requested_by,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} requested ON  requested.id = #{table_name}.requested_by").
    select("requested.full_name requested_name")
  }

  scope :with_organization,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Organization.view_name} ON #{Irm::Organization.view_name}.id = requested.organization_id AND #{Irm::Organization.table_name}.language = '#{language}").
    select("#{Irm::Organization.view_name} organization_name")
  }

  scope :query_by_requested,lambda{|requested_by|
    where(:requested_by=>requested_by)
  }


  # 查询出提交人
  scope :with_submitted_by,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} submitted ON  submitted.id = #{table_name}.submitted_by").
    select("#{Irm::Person.name_to_sql(nil,'submitted','submitted_name')}")
  }

  # 查询出supporter
  scope :with_supporter,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} supporter ON  supporter.id = #{table_name}.support_person_id").
    select("#{Irm::Person.name_to_sql(nil,'supporter','support_person_name')}")
  }

  # 查询supporter的组织
  scope :with_supporter_organization, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Organization.view_name} org ON org.id = supporter.organization_id AND org.language = '#{language}'").
        select("org.name supporter_organization_name")
  }

  # 查询supporter的角色
  scope :with_supporter_role, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Role.view_name} rl ON rl.id = supporter.role_id AND rl.language = '#{language}'").
        select("rl.name supporter_role_name")
  }

  # 查询supporter的简档
  scope :with_supporter_profile, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Profile.view_name} pf ON pf.id = supporter.profile_id AND pf.language = '#{language}'").
        select("pf.name supporter_profile_name")
  }

  # 查询出优先级
  scope :with_support_group,lambda{|language|
    joins("LEFT OUTER JOIN #{Icm::SupportGroup.table_name} ON  #{table_name}.support_group_id = #{Icm::SupportGroup.table_name}.id").
    joins("LEFT OUTER JOIN #{Irm::Group.view_name} ON  #{Icm::SupportGroup.table_name}.group_id = #{Irm::Group.view_name}.id AND #{Irm::Group.view_name}.language= '#{language}'").
    select(" #{Irm::Group.view_name}.name support_group_name")
  }

  scope :query_by_submitted,lambda{|submitted_by|
    where(:submitted_by=>submitted_by)
  }

  # 查询出紧急度
  scope :with_urgence,lambda{|language|
    joins("LEFT OUTER JOIN #{Icm::UrgenceCode.view_name} urgence_code ON  urgence_code.id = #{table_name}.urgence_id AND urgence_code.language= '#{language}'").
    select(" urgence_code.name urgence_name")
  }
  # 查询出影响度
  scope :with_impact_range,lambda{|language|
    joins("LEFT OUTER JOIN #{Icm::ImpactRange.view_name} impact_range ON  impact_range.id = #{table_name}.impact_range_id AND impact_range.language= '#{language}'").
    select(" impact_range.name impact_range_name")
  }
  # 查询出联系人
  scope :with_contact,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} contact ON  contact.id = #{table_name}.contact_id").
    select("#{Irm::Person.name_to_sql(nil,'contact','contact_name')}")
  }
  # 查询出报告来源
  scope :with_report_source,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} report_source ON report_source.lookup_type='ICM_REQUEST_REPORT_SOURCE' AND report_source.lookup_code = #{table_name}.report_source_code AND report_source.language= '#{language}'").
    select(" report_source.meaning report_source_name")
  }
  # 查询出事故单状态
  scope :with_incident_status,lambda{|language|
    joins("LEFT OUTER JOIN #{Icm::IncidentStatus.view_name} incident_status ON  incident_status.id = #{table_name}.incident_status_id AND incident_status.language= '#{language}'").
    joins("LEFT OUTER JOIN #{Icm::IncidentPhase.view_name} incident_phase ON  incident_phase.phase_code = incident_status.phase_code AND incident_phase.language= '#{language}'").
    select(" incident_status.name incident_status_name,incident_phase.name incident_phase_name ,incident_status.close_flag close_flag")
  }

  scope :with_external_system, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::ExternalSystem.view_name} external_system ON external_system.id = #{table_name}.external_system_id AND external_system.language = '#{language}'").
        select("external_system.system_name external_system_name")
  }
  scope :query_by_support_person, lambda{|person_id|
    where("#{table_name}.support_person_id = ?", person_id)
  }
  # use with_contact with_requested_by with_submmitted_by
  scope :relate_person,lambda{|person_id|
    where("#{table_name}.requested_by = ? OR #{table_name}.submitted_by = ? OR #{table_name}.contact_id = ? OR #{table_name}.support_person_id = ? OR EXISTS(SELECT 1 FROM #{Irm::Watcher.table_name} watcher WHERE watcher.watchable_id = #{table_name}.id AND watcher.watchable_type = ? AND watcher.member_id = ? AND watcher.member_type = ? ) OR (#{table_name}.support_group_id IS NOT NULL AND #{table_name}.support_person_id IS NULL AND EXISTS(SELECT 1 FROM #{Icm::SupportGroup.table_name} sg,#{Irm::GroupMember.table_name} gm WHERE gm.group_id = sg.group_id AND sg.id = #{table_name}.support_group_id  AND gm.person_id = ?))",
    person_id,person_id,person_id,person_id,Icm::IncidentRequest.name,person_id,Irm::Person.name,person_id)
  }

  scope :filter_system_ids,lambda{|system_ids|
    if system_ids.length<1
      system_ids = system_ids+[0]
    end
    joins("JOIN #{Irm::ExternalSystem.table_name} ON #{Irm::ExternalSystem.table_name}.external_system_code = #{table_name}.external_system_code")
    where("#{table_name}.id IN (?)",system_ids)
  }

              scope :query_by_ids ,lambda{|ids|

            }
  scope :select_all,lambda{
    select("#{table_name}.*")
  }

  #报表使用
  scope :query_by_urgency,lambda{|language| select("v1.name urgency_name,sum(1) urgency_count").
                          joins(",icm_urgence_codes_vl v1").
                          where("v1.urgency_code = #{table_name}.urgence_code AND v1.language = '#{language}'").
                          group("v1.name")
  }

   scope :query_by_report_source,lambda{|language| select("v1.meaning report_source_name,sum(1) report_source_count").
                          joins(",irm_lookup_values_vl v1").
                          where("v1.lookup_code = #{table_name}.report_source_code AND v1.language = '#{language}' AND " +
                                "v1.lookup_type = 'ICM_REQUEST_REPORT_SOURCE'").
                          group("v1.meaning")}


   scope :query_by_request_type,lambda{|language| select("v1.meaning report_type_name,sum(1) report_type_count").
                          joins(",irm_lookup_values_vl v1").
                          where("v1.lookup_code = #{table_name}.request_type_code AND v1.language = '#{language}' AND " +
                                "v1.lookup_type = 'ICM_REQUEST_TYPE_CODE'").
                          group("v1.meaning")}


   scope :query_by_impact_range,lambda{|language| select("v1.name impact_range_name,sum(1) impact_range_count").
                          joins(",icm_impact_ranges_vl v1").
                          where("v1.impact_code = #{table_name}.impact_range_code AND v1.language = '#{language}'").
                          group("v1.name")}

   scope :query_by_priority_code,lambda{|language| select("v1.name priority_code_name,sum(1) priority_code_count").
                          joins(",icm_priority_codes_vl v1").
                          where("v1.priority_code = #{table_name}.priority_code AND v1.language = '#{language}'").
                          group("v1.name")}

   #已经关闭的事故单
   scope :query_by_completed_incident, where("#{table_name}.incident_status_code='CLOSE_INCIDENT'")

   #未解决的事故单
   scope :query_by_unsolved_incident, where("#{table_name}.incident_status_code not in ('CLOSE_INCIDENT','SOLVE_RECOVER')")
   #针对于支持组id和支持组人员为空，被认为未分配的
   scope :query_by_unallocated_incident, where("#{table_name}.support_person_id is null and " +
                                              "#{table_name}.support_group_id is null")

   #分月统计
   scope :query_all_year_month,select("DATE_FORMAT(#{table_name}.created_at,'%Y-%m') created_year_month,sum(1) incident_count").
                               group("DATE_FORMAT(#{table_name}.created_at,'%Y-%m')").
                               order("DATE_FORMAT(#{table_name}.created_at,'%Y-%m') asc")


   scope :assignable_to_person,lambda{|person_id|
     joins("JOIN #{Icm::SupportGroup.table_name} ON #{Icm::SupportGroup.table_name}.id = #{table_name}.support_group_id ").
         joins("JOIN #{Irm::GroupMember.table_name} ON #{Irm::GroupMember.table_name}.group_id = #{Icm::SupportGroup.table_name}.group_id").
         where("#{table_name}.support_person_id IS NULL AND #{Irm::GroupMember.table_name}.person_id = ?",person_id)
   }

  acts_as_watchable
  def self.list_all
    select_all.
        with_request_type(I18n.locale).
        with_service(I18n.locale).
        with_requested_by.
        with_urgence(I18n.locale).
        with_impact_range(I18n.locale).
        with_contact.
        with_report_source(I18n.locale).
        with_incident_status(I18n.locale).
        with_priority(I18n.locale).
        with_submitted_by.
        with_support_group(I18n.locale).
        with_supporter.
        with_external_system(I18n.locale).
        with_supporter_organization(I18n.locale).
        with_supporter_role(I18n.locale).
        with_supporter_profile(I18n.locale)
  end


  def self.search(query)
    self.list_all.where("#{table_name}.title like ?","%#{query}%")
  end

  def self.query_by_request_number(query)
    self.list_all.where(:request_number=>query)
  end

  def concat_journals
    return_val = ""
    self.incident_journals.each do |i|
      return_val << i.message_body.to_s
      return_val << "  "
    end
    return_val.gsub!(/<(br)(| [^>]*)>/i, "\n")
    Irm::Sanitize.sanitize(return_val.to_s,"")
  end

  def need_customer_reply
  # if the request is closed
   return "C" if self.close?
   # other person of the incident request
   return "O" unless Irm::Person.current.id.eql?(self.requested_by)||Irm::Person.current.id.eql?(self.support_person_id)
   if (self.last_request_date||self.created_at)>(self.last_response_date||self.created_at)
     Irm::Constant::SYS_NO
   else
     Irm::Constant::SYS_YES
   end
  end

  def need_assign
    if(self.support_group_id.nil?||self.support_group_id.blank?)
      Irm::Constant::SYS_YES
    else
      Irm::Constant::SYS_NO
    end
  end


  def close?
    Irm::Constant::SYS_YES.eql?(self.status_close_flag)
  end

  # setup close flag
  def status_close_flag
    return self.close_flag if self.close_flag
    if self[:close_flag]
      self.close_flag = self[:close_flag]
      return self.close_flag
    end
    status  = Icm::IncidentStatus.query(self.incident_status_id).first
    self.close_flag = status.close_flag if status
    return self.close_flag
  end

  def self.current_accessible(companies = [])
    bo = Irm::BusinessObject.where(:business_object_code=>"ICM_INCIDENT_REQUESTS").first
    incident_requests_scope = eval(bo.generate_query_by_attributes([:id], true)).order("close_flag ,last_response_date desc,last_request_date desc,weight_value")

    if !Irm::PermissionChecker.allow_to_function?(:view_all_incident_request)
      incident_requests_scope = incident_requests_scope.relate_person(Irm::Person.current.id)
    end

    incident_requests_scope.collect(&:id)
  end

  def sync_priority
    setup_priority
    self.save
  end

  def watcher_person_ids
    return @watcher_person_ids if @watcher_person_ids
    @watcher_person_ids = self.all_person_watchers.collect{|p|p[:person_id]}
    @watcher_person_ids
  end

  def watcher?(person_id)
    self.watcher_person_ids.include?(person_id)
  end

  private
  def generate_request_number
    count = self.class.count
    self.request_number = count
    self.save
    self.add_watcher(Irm::Person.find(self.support_person_id),false) if self.support_person_id.present?
    self.add_watcher(Irm::Person.find(self.requested_by),false)
    self.add_watcher(Irm::Person.find(self.submitted_by),false)
  end

  def setup_priority
    urgence = Icm::UrgenceCode.find(self.urgence_id)
    impact_range = Icm::ImpactRange.find(self.impact_range_id)
    self.weight_value = urgence.weight_values + impact_range.weight_values-1
    priority = Icm::PriorityCode.query_by_weight_value(self.weight_value).first
    self.priority_id = priority.id
  end

  def setup_organization
    if self.requested_by.present?
      self.organization_id =  Irm::Person.find(self.requested_by).organization_id
    end
  end
end
