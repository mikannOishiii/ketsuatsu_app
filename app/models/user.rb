class User < ApplicationRecord
  acts_as_reader
  has_many :records, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i(facebook twitter)

  validates :account_name, presence: true, uniqueness: true
  validates :accepted, presence: { message: 'を入力してください' }

  # omniauthのコールバック時に呼ばれるメソッド
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = User.send(:dummy_email, auth)
      user.password = Devise.friendly_token[0, 20]
      user.account_name = auth.info.name
      user.accepted = "true"
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end

  private_class_method :dummy_email
end
