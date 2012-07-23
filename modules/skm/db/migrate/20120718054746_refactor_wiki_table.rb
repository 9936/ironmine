class RefactorWikiTable < ActiveRecord::Migration
  def up
    rename_table  :irm_wikis,:skm_wikis
  end

  def down
    rename_table  :skm_wikis,:irm_wikis
  end
end
