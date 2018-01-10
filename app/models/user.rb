class User < ApplicationRecord
  has_many :user_lessons


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    user ||= User.create(
      email: data['email'],
      password: Devise.friendly_token[0, 20],
      first_name: data['first_name'],
      last_name: data['last_name'],
      image_url: data['image']
    )
    user
  end
end
