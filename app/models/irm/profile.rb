class Irm::Profile < ActiveRecord::Base
  set_table_name :irm_profiles
  #多语言关系
  attr_accessor :name,:description
  has_many :profiles_tls,:dependent => :destroy
  acts_as_multilingual

  has_many :profile_functions
  has_many :functions,:through => :profile_functions

  has_many :profile_applications
  has_many :applications,:through => :profile_applications

  #加入activerecord的通用方法和scope
  query_extend
  # 对运维中心数据进行隔离
  default_scope current_opu

  validates_presence_of :code
  validates_uniqueness_of :code, :scope => :opu_id

  scope :with_kanban, lambda{
    joins("LEFT OUTER JOIN #{Irm::ProfileKanban.table_name} pk ON pk.profile_id = #{table_name}.id").
        joins("LEFT OUTER JOIN #{Irm::Kanban.view_name} kb ON pk.kanban_id = kb.id AND kb.position_code='INCIDENT_REQUEST_PAGE' AND kb.language='#{I18n.locale}'").
        select("kb.name kanban_name, kb.id kanban_id")
  }

  def to_s
    Irm::Profile.multilingual.where(:id=>self.id).first[:name]
  end

  def function_ids
    return @function_ids if @function_ids
    operation_unit_function_ids = Irm::OperationUnit.current.function_ids
    profile_function_ids = self.profile_functions.collect{|i| i.function_id}
    sub_function_ids = profile_function_ids - operation_unit_function_ids
    @function_ids = profile_function_ids - sub_function_ids
  end

  def application_ids
    return @application_ids if @application_ids
    @application_ids = self.profile_applications.collect{|i| i.application_id}
  end


  def default_application_id
    return @default_application_id if @default_application_id
    default_application = self.profile_applications.detect{|i| Irm::Constant::SYS_YES.eql?(i.default_flag)}
    if default_application
      @default_application_id = default_application.application_id
    end
  end


  def ordered_applications
    @ordered_applications if @ordered_applications
    @ordered_applications = Irm::Application.multilingual.query_by_profile(self.id)
  end


  def create_from_function_ids(function_ids)
    return unless function_ids.is_a?(Array)&&function_ids.any?
    exists_functions = Irm::ProfileFunction.where(:profile_id=>self.id)
    exists_functions.each do |function|
      if function_ids.include?(function.function_id)
        function_ids.delete(function.function_id)
      else
        function.destroy
      end
    end

    function_ids.each do |fid|
      next unless fid
      self.profile_functions.build({:function_id=>fid})
    end if function_ids.any?
  end

  def create_from_application_ids(application_ids,default_application_id)
    return unless application_ids.is_a?(Array)&&application_ids.any?
    exists_applications = Irm::ProfileApplication.where(:profile_id=>self.id)
    exists_applications.each do |application|
      if application_ids.include?(application.application_id)
        application_ids.delete(application.application_id)
        default_options = {}
        default_options.merge!({:default_flag=>application.application_id.eql?(default_application_id) ? Irm::Constant::SYS_YES : Irm::Constant::SYS_NO}) if default_application_id.present?
        application.update_attributes({}.merge(default_options))
      else
        application.destroy
      end

    end

    application_ids.each do |aid|
      next unless aid.present?
      default_options = {}
      default_options.merge!({:default_flag=>aid.eql?(default_application_id) ? Irm::Constant::SYS_YES : Irm::Constant::SYS_NO}) if default_application_id.present?
      self.profile_applications.build({:application_id=>aid}.merge(default_options))
    end if application_ids.any?
  end

  def clone_application_relation_from_profile(existing_profile)
    return unless existing_profile
    ex_app_relations = Irm::ProfileApplication.where(:profile_id => existing_profile.id)
    ex_app_relations.each do |er|
      Irm::ProfileApplication.create(:profile_id => self.id, :application_id => er.application_id, :default_flag => er.default_flag)
    end
  end

  def clone_function_relation_from_profile(existing_profile)
    return unless existing_profile
    ex_fun_relations = Irm::ProfileFunction.where(:profile_id => existing_profile.id)
    ex_fun_relations.each do |ef|
      Irm::ProfileFunction.create(:profile_id => self.id, :function_id => ef.function_id)
    end
  end

  def clone_kanban_relation_from_profile(existing_profile)
    return unless existing_profile
    ex_kanban_relations = Irm::ProfileKanban.where(:profile_id => existing_profile.id)
    ex_kanban_relations.each do |ek|
      Irm::ProfileKanban.create(:profile_id => self.id, :opu_id => ek.opu_id, :kanban_id => ek.kanban_id)
    end
  end
end


