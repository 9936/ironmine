class InitNdmNewBranchSequence < ActiveRecord::Migration
  def up
    Irm::Sequence.create(:object_name => "NDM_BRANCH_YI",
                         :seq_max => 0,
                         :seq_length => 0,
                         :seq_next => 0)
    Irm::Sequence.create(:object_name => "NDM_BRANCH_YEU",
                         :seq_max => 0,
                         :seq_length => 0,
                         :seq_next => 0)
  end

  def down
  end
end
