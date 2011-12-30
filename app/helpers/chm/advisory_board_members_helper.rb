module Chm::AdvisoryBoardMembersHelper
  def advisory_board_members(advisory_board_id)
    Chm::AdvisoryBoardMember.select_all.with_person(I18n.locale).where("advisory_board_id = ?",advisory_board_id)
  end
end
