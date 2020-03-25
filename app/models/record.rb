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

  scope :search_with_date, ->(date) { where("date = ?", date) }

  # 今月
  scope :current_month, -> { where(date: Time.now.beginning_of_month..Time.now.end_of_month) }
  # 先月
  scope :last_month, -> { where(date: Time.now.prev_month.beginning_of_month..Time.now.prev_month.end_of_month) }
end
