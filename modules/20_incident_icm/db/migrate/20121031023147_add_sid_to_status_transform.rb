class AddSidToStatusTransform < ActiveRecord::Migration
  def change
    add_column :icm_status_transforms, :sid, :string, :limit=>22, :collate=>"utf8_bin",:after => "opu_id"
  end
end
