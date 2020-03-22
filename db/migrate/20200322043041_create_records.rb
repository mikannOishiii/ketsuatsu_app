class CreateRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :records do |t|
      t.date :date
      t.integer :m_sbp
      t.integer :m_dbp
      t.integer :m_pulse
      t.integer :n_sbp
      t.integer :n_dbp
      t.integer :n_pulse
      t.text :memo
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :records, [:user_id, :created_at]
  end
end
