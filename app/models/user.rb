class User < ApplicationRecord
  # Extensions
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]

  # Associations
  has_many :authentications, dependent: :destroy, inverse_of: :user


  # Validations

end
