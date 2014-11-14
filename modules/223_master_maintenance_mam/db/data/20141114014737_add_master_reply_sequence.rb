class AddMasterReplySequence < ActiveRecord::Migration
  def up    opu = "001n00012i8IyyjJakd6Om"
    Irm::Sequence.create(:opu_id => opu,
                         :object_name => "MAM::ReplyNumber",
                         :seq_max => 0,
                         :seq_length => 0,
                         :seq_next => 1)
  end

  def down
  end
end
