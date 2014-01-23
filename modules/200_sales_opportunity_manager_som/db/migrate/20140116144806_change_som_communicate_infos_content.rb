class ChangeSomCommunicateInfosContent < ActiveRecord::Migration
  def change
    change_column(:som_communicate_infos,:content,:text)
  end

end
