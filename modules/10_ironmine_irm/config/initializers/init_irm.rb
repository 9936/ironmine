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
begin
::Ironmine::Acts::Searchable.searchable_entity = {Icm::IncidentRequest.name => "view_incident_request",
                                                  Csi::Survey.name => "view_survey",
                                                  Skm::EntryHeader.name => "view_skm_entries",
                                                  Irm::Bulletin.name => "bulletin",
                                                  Chm::ChangeRequest.name => "change_request",
                                                  Irm::AttachmentVersion.name => "attachment"}
rescue => text
  puts("Init module error :#{text}")
end
