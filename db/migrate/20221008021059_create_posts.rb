class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :image_path
      t.string :image_public_id

      t.timestamps
    end
  end
end
