require 'route_recognizer'

class User < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :username
  dragonfly_accessor :avatar

  devise :database_authenticatable, :registerable, :async,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]

  # Associations
  has_many :authentications, dependent: :destroy, inverse_of: :user
  has_many :user_skills, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :user
  has_many :skills, through: :user_skills


  # Validations
  validate  :username_not_in_routes
  validates :username, :uniqueness => { :case_sensitive => false },
            :format => { :with => /\A[\w\d\._-]+\Z/n,
            :message => "can only contain letters, numbers, underscores, dashes and dots" },
            :length => { :in => 0..50 }, allow_blank: true
  validates_size_of :avatar, maximum: 5.megabytes

  def onboarded?
    username.present?
  end

  def available_skills
    Skill.where.not(id: self.skills.pluck(:id))
  end

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

  def username_not_in_routes
    if RouteRecognizer.new.initial_path_segments.include?(username)
      errors.add(:username, "not available")
    end
  end
end
