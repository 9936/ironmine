class CreateComments < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.string :blog_id
      t.text :content
      t.references :blog
      t.timestamps
    end
    add_index :comments, :blog_id
  end

  def down
  end
end
