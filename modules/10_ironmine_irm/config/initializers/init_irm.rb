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
# IRM模块初始化脚本
  require File.dirname(__FILE__) + '/../../lib/irm/process_approve_mail_processor'
  require File.dirname(__FILE__) + '/../../lib/irm/process_mail_request_processor'
  require File.dirname(__FILE__) + '/../../lib/irm/process_mail_journal_processor'
#注册IRM模块菜单
  Irm::MenuManager.reset_menu

  module Wf
    class Error < ::StandardError;
    end
    class ApproveError < Error

    end

    class MissingSelectApproverError < ApproveError;
    end
    class MissingDefaultApproverError < ApproveError;
    end
    class MissingAutoApproverError < ApproveError;
    end
    class RollbackApproveError < ApproveError;
    end
  end
end

::Ironmine::Acts::Searchable.searchable_entity = {Icm::IncidentRequest.name => "view_incident_request"#,
                                                  #Csi::Survey.name => "view_survey",
                                                  #Skm::EntryHeader.name => "view_skm_entries",
                                                  #Irm::Bulletin.name => "bulletin",
                                                  #Chm::ChangeRequest.name => "change_request",
                                                  #Irm::AttachmentVersion.name => "attachment"
}
