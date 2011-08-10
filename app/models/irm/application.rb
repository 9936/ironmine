class Irm::Application < ActiveRecord::Base
  set_table_name :irm_applications

  attr_accessor :tabs_str,:default_tab_id

  #多语言关系
  attr_accessor :name,:description
  has_many :applications_tls,:dependent => :destroy
  acts_as_multilingual

  has_many :application_tabs,:order=>:seq_num,:dependent => :destroy
  has_many :tabs,:through =>:application_tabs
  has_many :profile_applications,:dependent => :destroy


  query_extend


  scope :query_by_profile ,lambda{|profile_id|
    joins("JOIN #{Irm::ProfileApplication.table_name} ON #{Irm::ProfileApplication.table_name}.application_id = #{table_name}.id").
    where("#{Irm::ProfileApplication.table_name}.profile_id = ?",profile_id).
    order("#{Irm::ProfileApplication.table_name}.default_flag DESC")
  }


  #创建 更新报表列
  def create_tabs_from_str
    return unless self.tabs_str
    str_tabs = self.tabs_str.split(",").delete_if{|i| !i.present?}
    str_tabs_indexes = str_tabs.dup
    exists_tabs = Irm::ApplicationTab.where(:application_id=>self.id)
    exists_tabs.each do |tab|
      if str_tabs.include?(tab.tab_id)
        str_tabs.delete(tab.tab_id)
        default_options = {}
        default_options.merge!({:default_flag=>tab.tab_id.eql?(self.default_tab_id) ? Irm::Constant::SYS_YES : Irm::Constant::SYS_NO}) if self.default_tab_id.present?
        tab.update_attributes({:seq_num=>str_tabs_indexes.index(tab.tab_id)+1}.merge(default_options))
      else
        tab.destroy
      end

    end

    str_tabs.each do |column_str|
      next unless column_str.strip.present?
      default_options = {}
      default_options.merge!({:default_flag=>column_str.eql?(self.default_tab_id) ? Irm::Constant::SYS_YES : Irm::Constant::SYS_NO}) if self.default_tab_id.present?
      self.application_tabs.build({:tab_id=>column_str,:seq_num=>str_tabs_indexes.index(column_str)+1}.merge(default_options))
    end if str_tabs.any?
  end


  def self.current
    @current||(Irm::Person.current.profile.present? ? Irm::Person.current.profile.ordered_applications.first : nil)
  end

  def self.current=(application)
    @current = application
  end

  def ordered_tabs
    return @ordered_tabs if @ordered_tabs
    @ordered_tabs = Irm::Tab.multilingual.with_function_group(I18n.locale).query_by_application(self.id)
  end

end
