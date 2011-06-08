# IRM模块初始化脚本
require File.dirname(__FILE__) + '/railtie'
#注册IRM模块菜单
Irm::MenuManager.reset_menu

module Wf
  class Error < ::StandardError; end
  class ApproverError < Error

  end

  class MissingSelectApproverError < ApproverError; end
  class MissingDefaultApproverError < ApproverError; end
  class MissingAutoApproverError < ApproverError; end
end


