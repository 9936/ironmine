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

  belongs_to :kanban, :class_name => "Irm::Kanban"

  has_many :profile_kanbans
  has_many :kanbans, :through => :profile_kanbans

  query_extend
#  scope :with

  scope :owned_kanbans, lambda{|profile_id|
    joins(",#{Irm::Kanban.table_name} kb,#{Irm::ProfileKanban.table_name} pk,#{Irm::KanbansTl.table_name} kt").
        joins(",#{Irm::LookupValue.view_name} lv").
        where("lv.language=?",I18n.locale).
        where("lv.lookup_type=?","IRM_KANBAN_POSITION").
        where("lv.lookup_code=pk.position_code").
        where("kb.id = pk.kanban_id").
        where("kb.id = kt.kanban_id").
        where("kt.language = ?", I18n.locale).
        where("pk.profile_id = #{table_name}.id").
        where("#{table_name}.id=?", profile_id).
        select("kb.id kanban_id, pk.limit kanban_limit, pk.refresh_interval refresh_interval, kt.name kanban_name, kt.description kanban_description, lv.meaning position_name, pk.position_code position_code, pk.id pk_id")
  }

  def to_s
    Irm::Profile.multilingual.where(:id=>self.id).first[:name]
  end

  def function_ids
    return @function_ids if @function_ids
    @function_ids = self.profile_functions.collect{|i| i.function_id}
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

  def get_pos_kanban(position_code)
    Irm::
  rescue
    false
  end
end


