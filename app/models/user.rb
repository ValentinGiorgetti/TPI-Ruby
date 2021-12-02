class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :rememberable, :validatable

  validates :name, :surname, presence: true, format: { with: /^[a-z A-Z]+$/, multiline: true }

  validates :role, presence: true
  
end