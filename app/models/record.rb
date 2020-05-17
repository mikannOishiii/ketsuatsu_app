class Record < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :date, presence: true
  validates :memo, length: { maximum: 20 }
  validate :cannot_be_in_the_future

  with_options length: { maximum: 3 }, numericality: { only_integer: true }, allow_nil: true do
    validates :m_sbp
    validates :m_dbp
    validates :m_pulse
    validates :n_sbp
    validates :n_dbp
    validates :n_pulse
  end

  def cannot_be_in_the_future
    if date.present? && date > Date.today
      errors.add(:date, :cannot_be_future_date)
    end
  end

  # 今月
  scope :current_month, -> { where(date: Time.now.beginning_of_month..Time.now.end_of_month) }
  # 先月
  scope :last_month, -> { where(date: Time.now.prev_month.beginning_of_month..Time.now.prev_month.end_of_month) }
  # 直近一週間
  scope :last_week, -> { where(date: 1.week.ago.beginning_of_day..Time.zone.now.end_of_day) }
end
