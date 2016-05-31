class CreateBlogs < ActiveRecord::Migration
  def up
    create_table :blogs do |t|
      t.string "title", :limit => 100, :null => false
      t.string "author", :limit => 100, :null => false
      t.string "content", :limit => 500, :null => false
      t.timestamps
    end
  end

  def down
  end
end
