class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :desc
      t.string :author
      t.string :url
      t.string :image
      t.string :ref_id

      t.timestamps null: false
    end

    add_index :posts, :ref_id, unique: true
  end
end
