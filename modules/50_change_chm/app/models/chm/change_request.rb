class Chm::ChangeRequest < ActiveRecord::Base
  set_table_name :chm_change_requests

  has_many :change_journals

  has_many :change_plans

  has_many :change_incident_relations

  has_many :change_config_relations


  validates_presence_of :title,:external_system_id,:requested_by,:submitted_by,:organization_id,
                        :change_impact_id,:change_urgency_id,:change_status_id,:change_priority_id,:request_type,
                        :contact_number,:contact_id
  acts_as_searchable

  #加入自定义字段
  acts_as_customizable

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope {default_filter}


  before_validation({:on => :create}) do
     setup_request_before_validation
  end

  before_create :setup_request_before_create

  validate :validate_summary


  scope :filter_system_ids,lambda{|system_ids|
    if system_ids.length<1
      system_ids = system_ids+[0]
    end
    where("#{table_name}.external_system_id IN (?)",system_ids)
  }

  scope :with_approve_status,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} approve_status ON approve_status.lookup_type='CHANGE_APPROVE_STATUS' AND approve_status.lookup_code = #{table_name}.approve_status AND approve_status.language= '#{language}'").
        select(" approve_status.meaning approve_status_name")
  }

  #系统
  scope :with_external_system, lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::ExternalSystem.view_name} external_system ON external_system.id = #{table_name}.external_system_id AND external_system.language = '#{language}'").
        select("external_system.system_name external_system_name")
  }
  # 类别
  scope :with_category,lambda{|language|
    if Ironmine::Application.config.fwk.modules.include?("icm")
      joins("LEFT OUTER JOIN #{Icm::IncidentCategory.view_name} ON  #{Icm::IncidentCategory.view_name}.id = #{table_name}.category_id AND #{Icm::IncidentCategory.view_name}.language= '#{language}'").
      joins("LEFT OUTER JOIN #{Icm::IncidentSubCategory.view_name} ON  #{Icm::IncidentSubCategory.view_name}.id = #{table_name}.sub_category_id AND #{Icm::IncidentSubCategory.view_name}.language= '#{language}'").
      select(" #{Icm::IncidentCategory.view_name}.name category_name,#{Icm::IncidentSubCategory.view_name}.name sub_category_name")
    else
      scoped
    end
  }

  # 优先级
  scope :with_change_priority,lambda{|language|
    joins("LEFT OUTER JOIN #{Chm::ChangePriority.view_name} priority ON  #{table_name}.change_priority_id = priority.id AND priority.language= '#{language}'").
    select(" priority.name change_priority_name")
  }

  # 影响度
  scope :with_change_impact,lambda{|language|
    joins("LEFT OUTER JOIN #{Chm::ChangeImpact.view_name} impact ON  #{table_name}.change_impact_id = impact.id AND impact.language= '#{language}'").
    select(" impact.name change_impact_name")
  }

  # 紧急度
  scope :with_change_urgency,lambda{|language|
    joins("LEFT OUTER JOIN #{Chm::ChangeUrgency.view_name} urgency ON  #{table_name}.change_urgency_id = urgency.id AND urgency.language= '#{language}'").
    select(" urgency.name change_urgency_name")
  }

  scope :with_organization,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Organization.view_name} ON #{Irm::Organization.view_name}.id = #{table_name}.organization_id AND #{Irm::Organization.view_name}.language = '#{language}'").
    select("#{Irm::Organization.view_name}.name organization_name")
  }

  # 查询出优先级
  scope :with_support,lambda{|language|
    if Ironmine::Application.config.fwk.modules.include?("icm")
      joins("LEFT OUTER JOIN #{Icm::SupportGroup.multilingual_view_name} support_group ON  #{table_name}.support_group_id = support_group.id AND support_group.language= '#{language}'").
      joins("LEFT OUTER JOIN #{Irm::Person.table_name} support_person ON  #{table_name}.support_person_id = support_person.id").
      select(" support_group.name support_group_name,support_person.full_name support_person_name")
    else
      scoped
    end
  }

  # 紧急度
  scope :with_change_status,lambda{|language|
    joins("LEFT OUTER JOIN #{Chm::ChangeStatus.view_name} status ON  #{table_name}.change_status_id = status.id AND status.language= '#{language}'").
    select(" status.name change_status_name")
  }


  # 查询出优先级
  scope :with_requested_by,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} requested_by ON  #{table_name}.requested_by = requested_by.id").
    select("requested_by.full_name requested_by_name")
  }

  # 查询出优先级
  scope :with_submitted_by,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} submitted_by ON  #{table_name}.submitted_by = submitted_by.id").
    select("submitted_by.full_name submitted_by_name")
  }

  # 查询出优先级
  scope :with_contact,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} contact ON  #{table_name}.contact_id = contact.id").
    select("contact.full_name contact_name")
  }

  # 查询出请求类型
  scope :with_request_type,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} request_type ON request_type.lookup_type='CHANGE_REQUEST_TYPE' AND request_type.lookup_code = #{table_name}.request_type AND request_type.language= '#{language}'").
    select(" request_type.meaning request_type_name")
  }

  searchable :auto_index => true, :auto_remove => true do
    text :title,:stored => true
    text :summary,:stored => true
    text :journals_content,:stored => true do
      change_journals.map(&:message_body)
    end
    time :updated_at
  end

  def self.search(query)
    search = Sunspot.search(Chm::ChangeRequest,Irm::AttachmentVersion) do |sq|
      sq.keywords query
      sq.facet :source_type => ['Chm::ChangeRequest', 'Chm::ChangeJournal']
    end
    #对result进行判断是否来自于附件，如果来自于附件需要对其进行特殊处理
    change_request_ids = []
    if search.results.any?
      search.results.each do |result|
        if result.class.to_s.eql?('Irm::AttachmentVersion')
          #如果搜索附件来自于回复
          if result.source_type.to_s.eql?('Chm::ChangeJournal')
            result = Chm::ChangeJournal.find(result.source_id)
            change_request_ids << result.change_request_id unless change_request_ids.include?(result.change_request_id)
          else
            change_request_ids << result.source_id unless change_request_ids.include?(result.source_id)
          end
        else
          change_request_ids << result.id unless change_request_ids.include?(result.id)
        end
      end
    end
    Chm::ChangeRequest.where("#{Chm::ChangeRequest.table_name}.id IN (?)", change_request_ids).list_all
  end

  def self.list_all
    select_all.with_external_system(I18n.locale).
        with_category(I18n.locale).
        with_change_priority(I18n.locale).
        with_change_impact(I18n.locale).
        with_change_urgency(I18n.locale).
        with_organization(I18n.locale).
        with_support(I18n.locale).
        with_change_status(I18n.locale).
        with_requested_by.
        with_submitted_by.
        with_contact.
        with_approve_status(I18n.locale).
        with_request_type(I18n.locale)
  end

  def self.request_files(request_id)
    files = Irm::AttachmentVersion.query_all.query_by_change_request(request_id).group_by{|a| a.source_id}
    files_belong_to_request = Irm::AttachmentVersion.query_change_request_file(request_id)

    files.merge!({0=>files_belong_to_request}) if files_belong_to_request.size > 0 #防止事故单没有附件的时候, 产生一个空的数组

    files
  end

  private
  # 在保存之前生成变更单号
  def setup_request_before_create
    count = self.class.count
    self.request_number = count+1
  end


  # 补全变更单信息
  def setup_request_before_validation
    # setup priority
    if self.change_urgency_id.present?&&self.change_impact_id.present?
      urgency = Chm::ChangeUrgency.find(self.change_urgency_id)
      impact = Chm::ChangeImpact.find(self.change_impact_id)
      weight_values = urgency.weight_values + impact.weight_values-1
      priority = Chm::ChangePriority.query_by_weight_value(weight_values).first
      self.change_priority_id = priority.id  if priority
    end
    self.submitted_by = Irm::Person.current.id unless self.submitted_by.present?
    self.submitted_date = Time.now

    unless self.change_status_id.present?
      self.change_status_id = Chm::ChangeStatus.default_id
    end

    unless self.request_type.present?
      self.request_type = "MAJOR"
    end

    unless self.requested_by.present?
      self.contact_id = self.requested_by
      self.organization_id = Irm::Person.find(self.requested_by).organization_id
    end

    if !self.contact_number.present?&&self.contact_id.present?
      self.contact_number = Irm::Person.find(self.contact_id).bussiness_phone
    end

    if self.requested_by.present?
      self.organization_id =  Irm::Person.find(self.requested_by).organization_id
    end

    if self.incident_request_id
      self.change_incident_relations.build({:incident_request_id=>self.incident_request_id,:create_flag=>"Y"})
    end
  end

  def validate_summary
    str = Irm::Sanitize.sanitize(self.summary,'').strip
    if !str.present?||(str.length==1&&str.bytes.to_a.eql?([226, 128, 139]))
      self.errors.add(:summary,I18n.t(:label_icm_incident_journal_message_body_not_blank))
    end
  end

end
