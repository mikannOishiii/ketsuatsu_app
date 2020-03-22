FactoryBot.define do
  factory :record do
    date { 2019/3/31 }
    m_sbp { 147 }
    m_dbp { 93 }
    m_pulse { 70 }
    n_sbp { 153 }
    n_dbp { 88 }
    n_pulse { 69 }
    memo { "MyMemo" }
    association :user
  end
end
