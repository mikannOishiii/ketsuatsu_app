class User < ApplicationRecord
  has_many :records, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, omniauth_providers: %i[facebook twitter]
  # omniauthのコールバック時に呼ばれるメソッド
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :account_name, presence: true, uniqueness: true
  validates :accepted, presence: {message: 'を入力してください'}
end
