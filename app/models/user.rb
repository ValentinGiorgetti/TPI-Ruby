class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable, 
         :omniauthable, omniauth_providers: [:google_oauth2]

  validates :name, :surname, presence: true, format: { with: /^[a-z A-Z áéíóú]+$/, multiline: true }

  validates :role, presence: true

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(name: data['first_name'], surname: data['last_name'], email: data['email'], 
                         password: Devise.friendly_token[0,20], role: 'consultant', new_user: true)
    end
    
    user
  end
  
end