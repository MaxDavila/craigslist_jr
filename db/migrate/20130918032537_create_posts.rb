class CreatePosts < ActiveRecord::Migration
  def up
    create_table :posts do |t|
      t.belongs_to :category
      t.string :title
      t.string :content
      t.string :email
      t.string :edit_id
      t.timestamps
    end
  end

  def down
    drop_table :posts
  end
end
