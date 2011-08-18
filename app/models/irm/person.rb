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

  validates_presence_of :login_name,:first_name,:email_address,:company_id
  validates_uniqueness_of :login_name, :if => Proc.new { |i| !i.login_name.blank? }
  validates_format_of :login_name, :with => /^[a-z0-9_\-@\.]*$/
  validates_length_of :login_name, :maximum => 30
  validates_presence_of :password,:if=> Proc.new{|i| i.hashed_password.blank?&&i.validate_as_person?}
  validates_confirmation_of :password, :allow_nil => true,:if=> Proc.new{|i|i.hashed_password.blank?||!i.password.blank?}
  validate :validate_password_policy,:if=> Proc.new{|i| i.password.present?&&i.password_confirmation.present?}

  validates_presence_of :title,:if => Proc.new { |i| i.validate_as_person? }
  validates_uniqueness_of :email_address, :if => Proc.new { |i| !i.email_address.blank? }
  validates_format_of :email_address, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i


  has_many :company_accesses
  query_extend

#  has_many :external_system_people,:class_name => "Uid::ExternalSystemPerson",
#           :foreign_key => "person_id",:primary_key => "id",:dependent => :destroy
#  has_many :external_systems,:class_name => "Uid::ExternalSystem",:through => :external_system_people

  has_attached_file :avatar,
                    :whiny => false,
                    :url => Irm::Constant::ATTACHMENT_URL,
                    :path => Irm::Constant::ATTACHMENT_PATH,
                    :styles => {:thumb => "16x16>",:medium => "45x45>",:large => "100x100>"},
                    :processors => [:cropper]

  validates_attachment_content_type :avatar,
                                    :content_type => ["image/jpg", "image/jpeg", "image/gif", "image/png", "image/jpeg", "image/x-png"],
                                    :message => "Accepted files include: jpg, gif, png"
#  validates_attachment_size :avatar, :less_than => Irm::SystemParametersManager.upload_file_limit.kilobytes

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  after_update :reprocess_avatar, :if => :cropping?

  after_create :access_default_company

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end


  scope :real,where(:type=>nil)
  scope :query_by_identity,lambda{|identity|
    where(:identity_id=>identity)
  }

  scope :query_person_name,lambda{|person_id|select("CONCAT(#{table_name}.last_name,#{table_name}.first_name) person_name").
                           where(:id=>person_id)}

  scope :query_all_person,select("#{table_name}.*")

  scope :query_by_company_id,lambda{|language| joins("inner join irm_companies_vl v2").
                                               where("v2.id=#{table_name}.company_id AND "+
                                                     "v2.language=?",language)}
  scope :query_by_support_staff_flag,lambda{|support_staff_flag| where(:support_staff_flag=>support_staff_flag)}

  scope :query_choose_person,select("#{table_name}.id,CONCAT(#{table_name}.last_name,#{table_name}.first_name) person_name,#{table_name}.email_address,#{table_name}.mobile_phone")



  scope :query_by_person_name,lambda{|person_name,language,support_group_code| select("#{table_name}.id,CONCAT(#{table_name}.last_name,#{table_name}.first_name) person_name,v2.name company_name,#{table_name}.email_address,v1.meaning status_meaning").
                                                   joins(",irm_companies_vl v2").
                                                   joins(",irm_lookup_values_vl v1").
                                                   where("v1.lookup_type='SYSTEM_STATUS_CODE' AND v1.lookup_code = #{table_name}.status_code AND "+
                                                         "v2.id = #{table_name}.company_id AND v2.language = ? AND " +
                                                         "CONCAT(#{table_name}.last_name,#{table_name}.first_name) LIKE '%#{person_name}%' AND " +
                                                         "v1.language=? AND NOT EXISTS (SELECT 1 FROM #{Irm::SupportGroupMember.table_name}  where " +
                                                         "support_group_code=? AND #{Irm::SupportGroupMember.table_name}.person_id = #{table_name}.id)",language,language,support_group_code)}

  scope :query_by_organization,lambda{|organization_id| where(:organization_id=>organization_id)}
  scope :query_by_department,lambda{|department_id| where(:department_id=>department_id)}
  scope :query_site_id,lambda{|site_id| where(:site_id=>site_id)}

  scope :with_company,lambda{|language|
    joins("JOIN #{Irm::Company.view_name} ON #{Irm::Company.view_name}.id = #{table_name}.company_id AND #{Irm::Company.view_name}.language = '#{language}'").
    select("#{Irm::Company.view_name}.name company_name")
  }

  scope :with_organization,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Organization.view_name} ON #{Irm::Organization.view_name}.id = #{table_name}.organization_id AND #{Irm::Organization.view_name}.language = '#{language}'").
    select("#{Irm::Organization.view_name}.name organization_name")
  }

  scope :with_department,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Department.view_name} ON #{Irm::Department.view_name}.id = #{table_name}.department_id AND #{Irm::Department.view_name}.language = '#{language}'").
    select("#{Irm::Department.view_name}.name department_name")
  }

  scope :with_region,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Region.view_name} ON #{Irm::Region.view_name}.region_code = #{table_name}.region_code AND #{Irm::Region.view_name}.language = '#{language}'").
    select("#{Irm::Region.view_name}.name region_name")
  }

  scope :with_site_group,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::SiteGroup.view_name} ON #{Irm::SiteGroup.view_name}.group_code = #{table_name}.site_group_code AND #{Irm::SiteGroup.view_name}.language = '#{language}'").
    select("#{Irm::SiteGroup.view_name}.name site_group_name")
  }

  scope :with_site,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Site.view_name} ON #{Irm::Site.view_name}.site_code = #{table_name}.site_code AND #{Irm::Site.view_name}.language = '#{language}'").
    select("#{Irm::Site.view_name}.name site_name")
  }

  scope :with_language,lambda{|language|
    joins("LEFT OUTER JOIN #{Irm::Language.view_name} ON #{Irm::Language.view_name}.language_code=#{table_name}.language_code AND #{Irm::Language.view_name}.language = '#{language}'").
    select("#{Irm::Language.view_name}.description language_description")
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

  scope :with_external_system, lambda{|external_system_code|
    select("#{table_name}.*").
        joins(",#{Uid::ExternalSystemPerson.table_name} esp").
        where("esp.external_system_code = ?", external_system_code).
        where("esp.person_id = #{table_name}.id")
  }

  scope :without_external_system, lambda{|external_system_code|
    select("#{table_name}.*").
        where("NOT EXISTS (SELECT * FROM #{Uid::ExternalSystemPerson.table_name} esp WHERE esp.person_id = #{table_name}.id AND esp.external_system_code = ?)", external_system_code)
  }

  scope :with_role, lambda{
    joins("LEFT OUTER JOIN #{Irm::Role.view_name} rv ON rv.id = #{table_name}.role_id AND rv.language='#{I18n.locale}' AND rv.status_code='#{Irm::Constant::ENABLED}'").
        select("rv.name role_name")
  }

  scope :with_profile, lambda{
    joins("LEFT OUTER JOIN #{Irm::Profile.view_name} pv ON pv.id = #{table_name}.profile_id AND pv.language='#{I18n.locale}' AND pv.status_code='#{Irm::Constant::ENABLED}'").
        select("pv.name profile_name")
  }

  def before_save
     #如果password变量值不为空,则修改密码
     self.hashed_password = Irm::Person.hash_password(self.password) if self.password&&!self.password.blank?
    if self.changes.keys.include?("first_name")||self.changes.keys.include?("last_name")
      process_full_name
    end
  end

  def self.list_all
        select_all.
        with_role.
        with_profile.
        with_company(I18n.locale).
        with_title(I18n.locale).
        with_organization(I18n.locale).
        with_department(I18n.locale).
        with_region(I18n.locale).
        with_site_group(I18n.locale).
        with_site(I18n.locale).
        with_language(I18n.locale).
        status_meaning
  end

  #取得系统当前登陆人员
  def self.current
    @current_person ||= Irm::Person.anonymous
  end
  #设置当前人员
  def self.current=(current_person)
    @current_person = current_person
  end

  def accessable_company_ids
    return @accessable_company_ids if @accessable_company_ids
    @accessable_company_ids = company_accesses.collect{|ca| ca.accessable_company_id}
    return @accessable_company_ids
  end

   #返回匿名用户,一个数据库中只有一个匿名用户
   def self.anonymous
     anonymous_person = Irm::AnonymousPerson.first
     if anonymous_person.nil?
       anonymous_person = Irm::AnonymousPerson.create(:login_name => 'anonymous', :first_name => 'anonymous',:email_address=>"anonymous@email.com",:hashed_password=>"nopassword",:company_id=>0)
       puts anonymous_person.errors
       raise 'Unable to create the anonymous person.' if anonymous_person.new_record?
     end
     anonymous_person
   end

   #判断是否已经登录
   def logged?
     true
   end

   #用户是否激活
   def active?
     true
   end

   # 加密密码
   def self.hash_password(clear_password)
     Digest::SHA1.hexdigest(clear_password || "")
   end

   # 用户登录
   def self.try_to_login(login, password)
     # Make sure no one can sign in with an empty password
     return nil if password.to_s.empty?
     person = find(:first, :conditions => ["login_name=?", login])
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


  # 用户所能访问的功能
  def functions
    return @function_ids if @function_ids
    @function_ids = Irm::Function.query_profile(self.profile_id).collect{|i|i.id}
  end


  def report_folders
    return @report_folders if @report_folders
    role_ids = []
    role_ids << self.role_id if self.role_id.present?
    role_report_folders = Irm::ReportFolder.multilingual.query_by_roles(role_ids)
    person_report_folders = Irm::ReportFolder.multilingual.query_by_person(self.id)
    public_report_folders = Irm::ReportFolder.multilingual.public
    @report_folders =  person_report_folders + role_report_folders + public_report_folders
    @report_folders.uniq!
    @report_folders
  end

  def external_systems
    Uid::ExternalSystem.multilingual.enabled.with_person(self.id)
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
    Irm::PaperclipHelper.gurl(attributes,style_name)
  end

  def self.avatar_path(attributes,style_name="original")
    attributes.merge!({:class_name=>self.name,:name=>"data"})
    Irm::PaperclipHelper.gpath(attributes,style_name)
  end

  def self.env
    {"env"=>{"language"=>Irm::Person.current.language_code.downcase}}
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

  private
  def reprocess_avatar
      avatar.reprocess!
  end


  def access_default_company
    Irm::CompanyAccess.create({:person_id=>self.id,:accessable_company_id=>self.company_id,:company_access_flag=>Irm::Constant::SYS_YES})
  end

  def validate_password_policy
    self.password_updated_at = Time.now
    unless Irm::PasswordPolicy.validate_password(self.password)
      self.errors[:password] = Irm::PasswordPolicy.validate_message
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
  def admin; false end
  def name(*args); ::I18n.t(:label_identity_anonymous) end
  def email; nil end
  def real?; false end
  def language_code; "en" end
end
