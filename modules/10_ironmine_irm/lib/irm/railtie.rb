module Irm
  class Railtie < Rails::Railtie
    config.to_prepare do
      Irm::SyncDataAccessExtend.instance.extend_data_access_model
    end
    # 自动对资源文件进行预编译
    initializer "irm.environment" do |app|
      #扩展ActionRecord::Base,实现数据保存时自动给created_by与updated_by赋值
      ActiveRecord::Base.send(:include, Irm::SetWho)
      #扩展ActionRecord::Base,自动生成scope query,active和instance方法active?
      ActiveRecord::Base.send(:include, Irm::QueryExtend)

      #扩展ActionRecord::Base,自动生成event
      ActiveRecord::Base.send(:include, Irm::EventGenerator)

      #扩展link_to,url_for,增加权限验证
      ActionView::Base.send(:include, Irm::UrlHelper)

      #扩展link_to,url_for,增加权限验证
      ActionView::Base.send(:include, Irm::FormHelper)
      ActionView::Base.send(:include, Irm::PageComponentHelper)

      #扩展event_calendar
      EventCalendar::ClassMethods.send(:include, EventCalendar::EventCalendarEx)

      #扩展calendar helper
      EventCalendar::CalendarHelper.send(:include, EventCalendar::CalendarHelperEx)

      #Paperclip.options[:command_path] = "E:/Program Files/ImageMagick-6.6.3-Q16"

      #require 'rufus/scheduler'
      # 程序中使用的ironmine中的常量，建议配置型的常量放到此处
      module Ironmine
        STORAGE = Fwk::DataStorage.instance
        # PERSON_NAME_FORMAT = :lastname_firstname

        #应用程序应用的host
        HOST = "zj.hand-china.com"

        PORT = "8282"

      end

      Ironmine::Acts::Searchable.searchable_entity = {Icm::IncidentRequest.name => "view_incident_request",
                                                      Csi::Survey.name => "view_survey",
                                                      Skm::EntryHeader.name => "view_skm_entries",
                                                      Irm::Bulletin.name => "bulletin",
                                                      Chm::ChangeRequest.name => "change_request"}

    end
  end
end