class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.text :title
      t.text :content
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
    add_index :posts, [:admin_id, :created_at]
  end
end
