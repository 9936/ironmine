# 该文件中的代码会在程序启动时自动运行,ironmine项目中需要初始的代码建议都放在此文件中


#ActionView::Base.field_error_proc=Proc.new{ |html_tag, instance|
#  msg = instance.error_message
#  error_css = "error"
#
#  if html_tag =~ /<(input|textarea|select)[^>]+class=/
#    css_attribute = html_tag =~ /class=['"]/
#    html_tag.insert(css_attribute + 7, "#{error_css} ")
#  elsif html_tag =~ /<(input|textarea|select)/
#    first_whitespace = html_tag =~ /\s/
#    html_tag[first_whitespace] = " class='#{error_css}' "
#  end
#
#  "#{html_tag}<div class=\"errorMsg\"><strong>#{I18n.t(:error)}:</strong>#{msg}</div>".html_safe
#}

#将rails 3中默认的javascript prototype库替换成jquery
#ActionView::Helpers::AssetTagHelper.register_javascript_expansion[:defaults]=%w(yui_config.js rails.js)

#扩展ActionRecord::Base,实现数据保存时自动给created_by与updated_by赋值
ActiveRecord::Base.send(:include,Irm::SetWho)
#扩展ActionRecord::Base,自动生成scope query,active和instance方法active?
ActiveRecord::Base.send(:include,Irm::QueryExtend)

#扩展ActionRecord::Base,自动生成event
ActiveRecord::Base.send(:include,Irm::EventGenerator)

ActiveModel::Errors.send(:include,Irm::ModelErrors)

#扩展ActionRecord::Base,使用客户化的ID
ActiveRecord::Base.send(:include,Irm::CustomId)

#扩展link_to,url_for,增加权限验证
ActionView::Base.send(:include,Irm::UrlHelper)

#扩展link_to,url_for,增加权限验证
ActionView::Base.send(:include,Irm::FormHelper)
ActionView::Base.send(:include,Irm::PageComponentHelper)
ActionView::Base.send(:include,Irm::DataTableHelper)

#扩展event_calendar
EventCalendar::ClassMethods.send(:include, EventCalendar::EventCalendarEx)

#扩展calendar helper
EventCalendar::CalendarHelper.send(:include, EventCalendar::CalendarHelperEx)

#Paperclip.options[:command_path] = "E:/Program Files/ImageMagick-6.6.3-Q16"

#require 'rufus/scheduler'
# 程序中使用的ironmine中的常量，建议配置型的常量放到此处
module Ironmine
  STORAGE = Irm::DataStorage.instance
# PERSON_NAME_FORMAT = :lastname_firstname

   #应用程序应用的host
   HOST = "zj.hand-china.com"

   PORT = "8282"

#attachment url,path
#   ATTACHMENT_URL = "/upload/:class/:id/:style/:basename.:extension"
#   ATTACHMENT_PATH = ":rails_root/public/upload/:class/:id/:style/:basename.:extension"

#   SCHEDULER = Rufus::Scheduler.start_new
end
#require File.expand_path('../../../lib/delayed_extends/delayed_job_log_function.rb', __FILE__)

Delayed::Backend::ActiveRecord::Job.send(:include,Irm::ExtendsLogDelayedJob)
Delayed::Worker.send(:include,Irm::ExtendsLogDelayedWorker)

#配置delayed_job
#当job执行失败,是否从队列中删除
Delayed::Worker.destroy_failed_jobs = false
#worker在没有job需要执行时的sleep时间,设为1s
Delayed::Worker.sleep_delay = 1
#最大重新执行次数
Delayed::Worker.max_attempts = 3
#一个job的最长执行时间
Delayed::Worker.max_run_time = 5.minutes
#数据存储方式
Delayed::Worker.backend=:active_record

Delayed::Backend::Base::ClassMethods.send(:include, Irm::DelayedJobBaseEx)

# 修改paperclip的验证方法,添加对Proc的支持
Paperclip::ClassMethods.send(:include,Irm::PaperclipValidator)

# 加载报表类
Dir[Rails.root.join('program', 'report', '**', '*.rb')].each do |file_path|
  require "#{file_path}"
end
Dir[Rails.root.join('modules','*','program', 'report', '**', '*.rb')].each do |file_path|
  require "#{file_path}"
end

begin
  # 初始化模块数据 ，初始化脚本位于lib/模块/init.rb脚本中
  Irm::ProductModule.enabled.each do |p|
    if File::exists?(File.join(File.expand_path(File.dirname(__FILE__)), "..","..","lib","#{p.product_short_name.downcase}","init.rb"))
      require "#{p.product_short_name.downcase}/init"
    end
  end
  rescue =>text
          puts("Init module error :#{text}")
end

Array.send :include, Irm::ArrayToJson

# 配置paperclip
# Paperclip.options[:command_path] = "C:/Applications/ImageMagick-6.6.7-Q16"
Paperclip::Attachment.default_options[:url] = "/upload/:class/:id/:style/:basename.:extension"
Paperclip::Attachment.default_options[:path] = ":rails_root/public/upload/:class/:id/:style/:basename.:extension"


# format xml
ActiveRecord::XmlSerializer::Attribute.send(:include,Irm::XmlAttribute)

# 修改session_store
ActiveRecord::SessionStore.send(:include,Irm::SessionStore)

Ironmine::Acts::Searchable.searchable_entity = {Icm::IncidentRequest.name=>"view_incident_request",
                                                 Csi::Survey.name=>"view_survey",
                                                 Skm::EntryHeader.name=>"view_skm_entries",
                                                Irm::Bulletin.name=>"bulletin",
                                                Chm::ChangeRequest.name => "change_request"}


begin

#初始化系统参数
#Irm::SystemParametersManager.prepare_system_parameters_cache


end

#sunspot_plus
#require 'sunspot_rails'
Sunspot.session = Sunspot::SessionProxy::DelayedJobSessionProxy.new(Sunspot.session)