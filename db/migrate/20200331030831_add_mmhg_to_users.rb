class AddMmhgToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :m_sbp, :integer
    add_column :users, :m_dbp, :integer
    add_column :users, :n_sbp, :integer
    add_column :users, :n_dbp, :integer
  end
end
