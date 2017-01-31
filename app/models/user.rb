class User < ApplicationRecord
  # Extensions
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]

  # Associations
  has_many :authentications, dependent: :destroy, inverse_of: :user


  # Validations


  def self.from_omniauth(omniauth, signed_in_resource=nil)
    # get auth model from omniauth data
    auth = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])

    if auth.present?
      # auth exists, update it
      user = auth.user
      
    elsif signed_in_resource
      # user exists, no auth exists
      user = signed_in_resource
      auth = user.authentications.build
    end

    if user.nil?
      email = omniauth["info"]["email"]
      # see if user exists with match auth email
      user = User.find_by_email(email)
      if user.nil?
        # user doesn't exist, create one
        user = User.create(:email => email, :password => Devise.friendly_token[0, 20], name: omniauth["info"]["name"])
      end
      auth = user.authentications.build
    end

    auth.from_omniauth(omniauth)
    auth.save

    return user
  end
end
