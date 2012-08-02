# IRM模块初始化脚本
require File.dirname(__FILE__) + '/process_approve_mail_processor'
require File.dirname(__FILE__) + '/process_mail_request_processor'
require File.dirname(__FILE__) + '/process_mail_journal_processor'
#注册IRM模块菜单
Irm::MenuManager.reset_menu

module Wf
  class Error < ::StandardError; end
  class ApproveError < Error

  end

  class MissingSelectApproverError < ApproveError; end
  class MissingDefaultApproverError < ApproveError; end
  class MissingAutoApproverError < ApproveError; end
  class RollbackApproveError < ApproveError; end
end


