# 设置fwk
#扩增SunspotSessionProxy,将索引的创建过程放到delayed_job中
Sunspot.session = Fwk::Sunspot::DelayedJobSessionProxy.new(::Sunspot.session)

#扩展ActionRecord::Base,使用客户化的ID
ActiveRecord::Base.send(:include, Fwk::CustomId)

#添加数组转化为json的功能
Array.send :include, Fwk::ArrayToJson
#添加页面表格功能
ActionView::Base.send(:include, Fwk::DataTableHelper)
#扩展link_to,url_for,增加权限验证
ActionView::Base.send(:include, Fwk::FormHelper)
ActionView::Base.send(:include, Fwk::PageComponentHelper)
require "delayed/backend/active_record"
# 扩展delayed_job
Delayed::Backend::Base::ClassMethods.send(:include, Fwk::DelayedJobBaseEx)

Delayed::Backend::ActiveRecord::Job.send(:include, Fwk::ExtendsLogDelayedJob)
Delayed::Worker.send(:include, Fwk::ExtendsLogDelayedWorker)

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

ActiveModel::Errors.send(:include, Fwk::ModelErrors)
# 修改paperclip的验证方法,添加对Proc的支持
Paperclip::ClassMethods.send(:include, Fwk::PaperclipValidator)
# 配置paperclip
# Paperclip.options[:command_path] = "C:/Applications/ImageMagick-6.6.7-Q16"
Paperclip::Attachment.default_options[:url] = "/upload/:class/:id/:style/:basename.:extension"
Paperclip::Attachment.default_options[:path] = ":rails_root/public/upload/:class/:id/:style/:basename.:extension"

# 修改session_store
ActiveRecord::SessionStore.send(:include, Fwk::SessionStore)

# format xml
ActiveRecord::XmlSerializer::Attribute.send(:include, Fwk::XmlAttribute)
