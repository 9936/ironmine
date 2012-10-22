require 'paperclip_processors/cropper'
require 'hz2py'
include Paperclip
class Irm::Person < ActiveRecord::Base
  set_table_name :irm_people

  attr_accessor :old_password,:password, :password_confirmation,:template_flag

  PERSON_NAME_FORMATS = {
    :lastname_firstname => '#{first_name} #{last_name}',
    :firstname => '#{first_name}',
    :firstname_lastname => '#{last_name}#{first_name}',
    :lastname_coma_firstname => '#{last_name},#{first_name}'
  }

  PERSON_NAME_SQL_FORMATS = {
    :lastname_firstname => " CONCAT(\#{alias_table_name}.first_name,' ',\#{alias_table_name}.last_name) \#{alias_column_name}",
    :firstname => " \#{alias_table_name}.first_name \#{alias_column_name}",
    :firstname_lastname => " CONCAT(\#{alias_table_name}.last_name,\#{alias_table_name}.first_name) \#{alias_column_name}",
    :lastname_coma_firstname =>  " CONCAT(\#{alias_table_name}.last_name,',',\#{alias_table_name}.first_name) \#{alias_column_name}"
  }

  belongs_to :profile
  belongs_to :operation_unit,:foreign_key => :opu_id

  validates_presence_of :login_name,:first_name,:email_address, :time_zone, :profile_id, :organization_id,:bussiness_phone
  #validates_presence_of :bussiness_phone,:if=> Proc.new{|i| i.validate_as_person?}
  validates_format_of :bussiness_phone, :with => /^[0-9\-]*$/,:message=>:phone_number ,:if => Proc.new { |i| i.bussiness_phone.present?}
  validates_uniqueness_of :login_name, :if => Proc.new { |i| !i.login_name.blank? }
  validates_format_of :login_name, :with => /^[a-z0-9_\-@\.]*$/,:message=>:downcase_number
  validates_length_of :login_name, :maximum => 30
  validates_presence_of :password,:if=> Proc.new{|i| i.hashed_password.blank?&&i.validate_as_person?}
  validates_confirmation_of :password, :allow_nil => true,:if=> Proc.new{|i|i.hashed_password.blank?||!i.password.blank?}
  validate :validate_password_policy,:if=> Proc.new{|i| i.password.present?&&i.password_confirmation.present?}

  validates_uniqueness_of :email_address, :if => Proc.new { |i| !i.email_address.blank? }
  validates_format_of :email_address, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,:message=>:email

  has_many :external_system_people,:class_name => "Irm::ExternalSystemPerson",
          :foreign_key => "person_id",:primary_key => "id",:dependent => :destroy
  has_many :external_systems,:class_name => "Irm::ExternalSystem",:through => :external_system_people

  has_many :group_members,:class_name => "Irm::GroupMember",:foreign_key => "person_id",:primary_key => "id",:dependent => :destroy
  has_many :groups,:class_name => "Irm::Group",:through => :group_members


  has_many :channel_approval_people, :class_name => 'Skm::ChannelApprovalPerson', :dependent => :destroy

  has_many :user_tokens, :class_name => "Irm::UserToken", :dependent => :destroy

  has_attached_file :avatar,
                    :whiny => false,
                    :styles => {:thumb => "16x16>",:medium => "45x45>",:large => "100x100>"},
                    :default_url => "/images/miss_avatar.gif",
                    :processors => [:cropper]

  validates_attachment_content_type :avatar,
                                    :content_type => ["image/jpg", "image/jpeg","image/pjpeg", "image/gif", "image/png", "image/jpeg", "image/x-png"],
                                    :message => :only_image
#  validates_attachment_size :avatar, :less_than => Irm::SystemParametersManager.upload_file_limit.kilobytes

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  after_update :reprocess_avatar, :if => :cropping?


  #加入activerecord的通用方法和scope
  query_extend
  default_scope {default_filter}

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end


  scope :real,where(:type=>nil)
  scope :not_anonymous,where("#{table_name}.login_name != ?","anonymous")
  scope :query_by_identity,lambda{|identity|
    where(:identity_id=>identity)
  }

  scope :query_person_name,lambda{|person_id|select("CONCAT(#{table_name}.last_name,#{table_name}.first_name) person_name").
                           where(:id=>person_id)}

  scope :query_all_person,select("#{table_name}.*")

  scope :query_by_support_staff_flag,lambda{|support_staff_flag| where(:support_staff_flag=>support_staff_flag)}

  scope :query_choose_person,select("#{table_name}.id,CONCAT(#{table_name}.last_name,#{table_name}.first_name) person_name,#{table_name}.email_address,#{table_name}.mobile_phone")

  scope :query_by_organization,lambda{|organization_id| where(:organization_id=>organization_id)}
  scope :query_site_id,lambda{|site_id| where(:site_id=>site_id)}


  scope :with_organization,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Organization.view_name} ON #{Irm::Organization.view_name}.id = #{table_name}.organization_id AND #{Irm::Organization.view_name}.language = '#{language}'").
    select("#{Irm::Organization.view_name}.name organization_name")
  }


  scope :with_language,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Language.view_name} ON #{Irm::Language.view_name}.language_code=#{table_name}.language_code AND #{Irm::Language.view_name}.language = '#{language}'").
    select("#{Irm::Language.view_name}.description language_description")
  }

  scope :with_notification_lang,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Language.view_name} nl ON nl.language_code=#{table_name}.notification_lang AND nl.language = '#{language}'").
    select("nl.description notification_lang_description")
  }

  scope :with_delegate_approver,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} delegate ON delegate.id=#{table_name}.delegate_approver").
    select("#{Irm::Person.name_to_sql(nil,'delegate','delegate_name')}")
  }

  scope :with_manager,lambda{
    joins("LEFT OUTER JOIN #{Irm::Person.table_name} manager ON manager.id=#{table_name}.manager").
    select("#{Irm::Person.name_to_sql(nil,"manager",'manager_name')}")
  }

  # query title
  scope :with_title,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::LookupValue.view_name} title ON title.lookup_type='IRM_PERSON_TITLE' AND title.lookup_code = #{table_name}.title AND title.language= '#{language}'").
    select(" title.meaning title_name")
  }

  scope :select_all,lambda{
    select("#{table_name}.*,#{Irm::Person.name_to_sql(nil,table_name,"person_name")}")
  }

  scope :with_external_system, lambda{|external_system_id|
    select("#{table_name}.*").
        joins(",#{Irm::ExternalSystemPerson.table_name} esp").
        where("esp.external_system_id = ?", external_system_id).
        where("esp.person_id = #{table_name}.id")
  }

  scope :without_external_system, lambda{|external_system_id|
    select("#{table_name}.*").
        where("NOT EXISTS (SELECT * FROM #{Irm::ExternalSystemPerson.table_name} esp WHERE esp.person_id = #{table_name}.id AND esp.external_system_id = ?)", external_system_id)
  }

  scope :with_approvals, lambda {|channel_id|
    select("#{table_name}.*").
        where("#{table_name}.id IN (?)" ,Skm::Channel.find(channel_id).channel_approval_people.collect{|i| i.person_id})
  }

  scope :without_approvals, lambda {|channel_id|
    select("#{table_name}.*").
        where("NOT EXISTS (SELECT * FROM #{Skm::ChannelApprovalPerson.table_name} cap WHERE cap.person_id = #{table_name}.id AND cap.channel_id = ?)", channel_id)
  }

  scope :group_memberable, lambda{|group_id|
    where("NOT EXISTS (SELECT 1 FROM #{Irm::GroupMember.table_name}  WHERE #{Irm::GroupMember.table_name}.person_id = #{table_name}.id AND #{Irm::GroupMember.table_name}.group_id = ?)",group_id).
    select("#{table_name}.id,#{table_name}.full_name person_name,#{table_name}.email_address")
  }

  scope :group_member, lambda{|group_id|
    joins("JOIN #{Irm::GroupMember.table_name} ON  #{Irm::GroupMember.table_name}.person_id = #{table_name}.id").
    where(" #{Irm::GroupMember.table_name}.group_id = ?",group_id).
    select("#{table_name}.id,#{table_name}.full_name person_name,#{table_name}.email_address")
  }

  scope :with_role, lambda{
    joins("LEFT OUTER JOIN #{Irm::Role.view_name} rv ON rv.id = #{table_name}.role_id AND rv.language='#{I18n.locale}' AND rv.status_code='#{Irm::Constant::ENABLED}'").
        select("rv.name role_name")
  }

  scope :with_profile, lambda{
    joins("LEFT OUTER JOIN #{Irm::Profile.view_name} pv ON pv.id = #{table_name}.profile_id AND pv.language='#{I18n.locale}' AND pv.status_code='#{Irm::Constant::ENABLED}'").
        select("pv.name profile_name")
  }

  scope :with_ldap, lambda{
    joins("LEFT OUTER JOIN #{Irm::LdapAuthHeader.table_name} lds ON lds.id = #{table_name}.auth_source_id").
        select("lds.name ldap_source_name, IF(lds.name is NULL, 'N', 'Y') ldap_flag")
  }
  before_save do
     #如果password变量值不为空,则修改密码
     self.hashed_password = Irm::Person.hash_password(self.password) if self.password&&!self.password.blank?
    if self.changes.keys.include?("first_name")||self.changes.keys.include?("last_name")
      process_full_name
    end
  end

  def self.list_all
        select_all.
        with_ldap.
        with_role.
        with_profile.
        with_title(I18n.locale).
        with_organization(I18n.locale).
        with_language(I18n.locale).
        with_notification_lang(I18n.locale).
        status_meaning
  end

  def self.list_all_a
        select_all.
        with_role.
        with_profile.
        with_organization(I18n.locale).
        with_language(I18n.locale).
        with_notification_lang(I18n.locale)
  end

  def self.lov(origin_scope,params)
    puts params.to_json
    return origin_scope
  end

  #取得系统当前登陆人员
  def self.current
    @current_person ||= Irm::Person.anonymous
  end
  #设置当前人员
  def self.current=(current_person)
    @current_person = current_person
  end

   def self.anonymous
     anonymous_person = Irm::AnonymousPerson.unscoped.first
     if anonymous_person.nil?
       anonymous_person = Irm::AnonymousPerson.create(:login_name => 'anonymous', :first_name => 'anonymous',:email_address=>"anonymous@email.com",:hashed_password=>"nopassword",:opu_id=>"anonymous")
       puts anonymous_person.errors
       raise 'Unable to create the anonymous person.' if anonymous_person.new_record?
     end
     anonymous_person
   end

   #判断是否已经登录
   def logged?
     true
   end

  def is_ldap?
    return false if self.auth_source_id.blank?
    true
  end

   #用户是否激活
   def active?
     !self.locked?&&self.enabled?
   end

   def locked?
     Irm::Constant::SYS_YES.eql?(self.locked_flag)&&(self.locked_until_at.nil?||self.locked_until_at>Time.now)
   end

   # 错误登录次数+1
   def add_lock_time
     self.locked_time = self.locked_time+1
     if Irm::PasswordPolicy.locked?(self.locked_time,self.opu_id)
       self.locked_until_at = Irm::PasswordPolicy.lock_until_date(self.opu_id) unless self.locked_flag.eql?(Irm::Constant::SYS_YES)&&self.locked_until_at>Time.now
       self.locked_flag = Irm::Constant::SYS_YES
     end
   end

   #对用户解除锁定
   def unlock
     self.locked_time = 0
     self.locked_flag = Irm::Constant::SYS_NO
     self.locked_until_at = nil
   end

  # 重置密码
  def reset_password
    self.password = Irm::PasswordPolicy.random_password(self.opu_id)
    self.password_updated_at = Irm::PasswordPolicy.expire_date(self.opu_id)
    self.unlock
    if self.save
      Delayed::Job.enqueue(Irm::Jobs::ResetPasswordMailJob.new(self.id,{:password=>self.password}), 0,Time.now )
    end
  end

   # 加密密码
   def self.hash_password(clear_password)
     Digest::SHA1.hexdigest(clear_password || "")
   end

   # 用户登录
   def self.try_to_login(login, password)
     # Make sure no one can sign in with an empty password
     return nil if password.to_s.empty?
     person =unscoped.where("login_name=?", login).first
     if person
       # user is already in local database
       # user is disabled
       return nil if !person.enabled?
       # ldap user login
       if person.auth_source_id.present?
         ldap_auth_header = Irm::LdapAuthHeader.find(person.auth_source_id)
         person_id = ldap_auth_header.authenticate(login,password)
         if person_id
           person = Irm::Person.find(person_id)
         else
           return nil
         end
       else
         return nil unless Irm::Person.hash_password(password) == person.hashed_password
       end
     else
       person_id = Irm::LdapAuthHeader.try_to_login(login,password)
       if person_id
         person = Irm::Person.find(person_id)
       else
         return nil
       end
     end

     person.update_attribute(:last_login_at, Time.now) if person && !person.new_record?
     return person
     rescue => text
     raise text
   end


  # 检查用户是否允许访问功能
  def allowed_to?(function_ids)
    return true if function_ids.detect{|fi| functions.include?(fi)}
    return true if Irm::Person.current.login_name.eql?("admin")
    false
  end

  # 刷新关系表
  def self.refresh_relation_table
    #ActiveRecord::Base.connection.execute(%Q(LOCK TABLE irm_person_relations_tmp WRITE))
    ActiveRecord::Base.connection.execute(%Q(DELETE FROM irm_person_relations_tmp))
    ActiveRecord::Base.connection.execute(%Q(INSERT INTO irm_person_relations_tmp SELECT * FROM irm_person_relations_v2))
  end

  # 用户所能访问的功能
  def functions
    return @function_ids if @function_ids
    if self.operation_unit&&self.operation_unit.primary_person_id.eql?(self.id)
      @function_ids = self.operation_unit.function_ids
      return @function_ids
    end
    if self.profile
      @function_ids = self.profile.function_ids
    else
      @function_ids = []
    end
    return @function_ids
  end


  def report_folders
    return @report_folders if @report_folders
    accessible_report_folders = Irm::ReportFolder.multilingual.accessible(self.id)
    private_report_folders = Irm::ReportFolder.multilingual.private(self.id)
    public_report_folders = Irm::ReportFolder.multilingual.public
    @report_folders =  accessible_report_folders + private_report_folders + public_report_folders
    @report_folders.uniq!
    @report_folders
  end

  def external_systems
    Irm::ExternalSystem.multilingual.enabled.with_person(self.id)
  end

  def system_ids
    return @system_ids if @system_ids
    @system_ids = self.external_systems.collect{|i| i.id}
  end


  # 返回人员的全名
  def name(formatter = nil)
      eval('"' + (PERSON_NAME_FORMATS[:firstname_lastname]) + '"')
  end
  # 取得人员全名的SQL
  def self.name_to_sql(formatter = nil,alias_table_name="#{table_name}",alias_column_name="name")
    eval('"' +PERSON_NAME_SQL_FORMATS[:firstname_lastname] + '"')
  end

  def self.admin
    Irm::Person.where(:login_name=>"admin").first
  end

  # get avatar
  # required :id,:filename,:updated_at
  def self.avatar_url(attributes,style_name="original")
    attributes.merge!({:class_name=>self.name,:name=>"data"})
    Fwk::PaperclipHelper.gurl(attributes,style_name)
  end

  def self.avatar_path(attributes,style_name="original")
    attributes.merge!({:class_name=>self.name,:name=>"data"})
    Fwk::PaperclipHelper.gpath(attributes,style_name)
  end

  def self.env
    {"env"=>{"language"=>(Irm::Person.current.language_code||"zh").downcase}}
  end

  def wrap_person_name
    self[:person_name]
  end

  def real?; true end

  def validate_as_person?;true end

  def process_full_name
      self.full_name = eval('"' + (PERSON_NAME_FORMATS[:firstname_lastname]) + '"')
      self.full_name_pinyin= Hz2py.do(self.full_name).downcase.gsub(/\s|[^a-z]/,"")
  end


  # 更新处理人员的最后分单时间

  def update_assign_date
    self.last_assigned_date = Time.now
  end


  def self.relation_view_name
    "irm_person_relations_v"
  end

  def password_same_as_before?(new_password)
    if Irm::Person.hash_password(new_password).eql?(self.hashed_password)
      self.errors.add(:password, I18n.t(:error_irm_person_new_old_password_same))
      return false
    end
    true
  end

  private
  def reprocess_avatar
      avatar.reprocess!
  end

  def validate_password_policy

    if Irm::PasswordPolicy.validate_password(self.password,self.opu_id)
      self.password_updated_at = Time.now
    else
      self.errors[:password] = Irm::PasswordPolicy.validate_message(self.opu_id)
    end
  end


end


class Irm::TemplatePerson < Irm::Person

  # Overrides a few properties
  def logged?; false end
  def real?; false end
  def validate_as_person?;false end
end


class Irm::AnonymousPerson < Irm::Person
  self.record_who = false
  def validate_on_create
    # There should be only one AnonymousUser in the database
    errors.add_to_base 'An anonymous person already exists.' if Irm::AnonymousPerson.first
  end


  # Overrides a few properties
  def validate_as_person?;false end
  def logged?; false end
  def active?
     true
   end
  def admin; false end
  def name(*args); ::I18n.t(:label_identity_anonymous) end
  def email; nil end
  def real?; false end
  def language_code; "en" end
end
