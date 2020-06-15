class CreatePictures < ActiveRecord::Migration[6.0]
  def change
    create_table :pictures do |t|
      t.string :name
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
    add_index :pictures, [:post_id, :created_at]
  end
end
