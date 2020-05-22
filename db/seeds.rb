require "csv"

User.create!(account_name:  "testuser",
             email: "test@example.com",
             password:              "foobar",
             password_confirmation: "foobar",
             accepted: true)

Admin.create!(account_name: "adminuser",
              email: "admin@example.com",
              password: "foobar",
              password_confirmation: "foobar")

CSV.foreach('db/csv/seeds.csv', headers: true) do |row|
  Record.create(
    date: row[0],
    m_sbp: row[1],
    m_dbp: row[2],
    m_pulse: row[3],
    n_sbp: row[4],
    n_dbp: row[5],
    n_pulse: row[6],
    memo: row[7],
    user_id: row[8]
  )
end
