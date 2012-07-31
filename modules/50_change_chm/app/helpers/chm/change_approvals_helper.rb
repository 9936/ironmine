module Chm::ChangeApprovalsHelper

  def change_approvals(change_request_id)
    Chm::ChangeApproval.list_all.where("#{Chm::ChangeApproval.table_name}.change_request_id = ? ",change_request_id)
  end
end
