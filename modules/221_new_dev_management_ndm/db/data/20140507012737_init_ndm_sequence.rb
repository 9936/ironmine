class InitNdmSequence < ActiveRecord::Migration
  def up
    Irm::Sequence.create(:object_name => Ndm::DevManagement.name,
                         :seq_max => 0,
                         :seq_length => 4,
                         :seq_next => 0)
  end

  def down
  end
end
