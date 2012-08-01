#扩展ActionRecord::Base,实现数据保存时自动给created_by与updated_by赋值
ActiveRecord::Base.send(:include, Irm::SetWho)
#扩展ActionRecord::Base,自动生成scope query,active和instance方法active?
ActiveRecord::Base.send(:include, Irm::QueryExtend)

#扩展ActionRecord::Base,自动生成event
ActiveRecord::Base.send(:include, Irm::EventGenerator)

#扩展link_to,url_for,增加权限验证
ActionView::Base.send(:include, Irm::UrlHelper)


#扩展event_calendar
EventCalendar::ClassMethods.send(:include, EventCalendar::EventCalendarEx)

#扩展calendar helper
EventCalendar::CalendarHelper.send(:include, EventCalendar::CalendarHelperEx)

# 程序中使用的ironmine中的常量，建议配置型的常量放到此处
module Ironmine
  STORAGE = Fwk::DataStorage.instance
  # PERSON_NAME_FORMAT = :lastname_firstname

  #应用程序应用的host
  HOST = "zj.hand-china.com"

  PORT = "8282"

end


begin
  # 初始化模块数据 ，初始化脚本位于lib/模块/init.rb脚本中
  Irm::ProductModule.enabled.each do |p|
    if File::exists?(File.join(File.expand_path(File.dirname(__FILE__)), "..", "..", "lib", "#{p.product_short_name.downcase}", "init.rb"))
      require "#{p.product_short_name.downcase}/init"
    end
  end
rescue => text
  puts("Init module error :#{text}")
end

::Ironmine::Acts::Searchable.searchable_entity = {Icm::IncidentRequest.name => "view_incident_request",
                                                  Csi::Survey.name => "view_survey",
                                                  Skm::EntryHeader.name => "view_skm_entries",
                                                  Irm::Bulletin.name => "bulletin",
                                                  Chm::ChangeRequest.name => "change_request"}


# 加载报表类
Rails.application.config.fwk.modules.reverse.each do |module_name|
  Dir[Rails.root.join('modules', Rails.application.config.fwk.module_mapping[module_name], 'reports', 'programs', module_name, '*.rb')].each do |file_path|
    require "#{file_path}"
  end
end