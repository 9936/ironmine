module Chm::AdvisoryBoardsHelper

  def available_advisory_board
    Chm::AdvisoryBoard.enabled.collect{|i| [i.name,i.id]}
  end
end
