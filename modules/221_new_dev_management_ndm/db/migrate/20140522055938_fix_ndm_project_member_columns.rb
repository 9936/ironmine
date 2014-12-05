class FixNdmProjectMemberColumns < ActiveRecord::Migration
  def up
    #permission control columns
    add_column :ndm_project_people, :vi, :string, :limit => 1, :default => 'N', :null => false, :after => :opu_id
    add_column :ndm_project_people, :ed, :string, :limit => 1, :default => 'N', :null => false, :after => :opu_id
    add_column :ndm_project_people, :re, :string, :limit => 1, :default => 'N', :null => false, :after => :opu_id
    add_column :ndm_project_people, :ad, :string, :limit => 1, :default => 'N', :null => false, :after => :opu_id
    add_column :ndm_project_people, :im, :string, :limit => 1, :default => 'N', :null => false, :after => :opu_id

    #project display sequence
    add_column :ndm_projects, :display_sequence, :integer, :default => 500, :after => :opu_id
  end

  def down
  end
end
