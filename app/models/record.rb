class Record < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :date, presence: true, uniqueness: true
  validates :memo, length: { maximum: 25 }

  with_options length: { maximum: 3 }, numericality: { only_integer: true }, allow_nil: true do
    validates :m_sbp
    validates :m_dbp
    validates :m_pulse
    validates :n_sbp
    validates :n_dbp
    validates :n_pulse
  end
end
