require 'route_recognizer'

class User < ApplicationRecord
  # Extensions
  include Admin::UserAdmin
  include PgSearch
  multisearchable :against => [:name, :username, :website_url, :skill_names, :role_names, :location_name, :is_hiring_name, :is_available_name, :remote_name]

  include UnpublishableActivity
  include Searchable
  extend FriendlyId
  friendly_id :username
  dragonfly_accessor :avatar
  is_impressionable
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]

  # Scope
  scope :admin,        -> { where(is_admin: true) }
  scope :normal,       -> { where(is_admin: false) }

  # Associations
  has_many :authentications, dependent: :destroy, inverse_of: :user
  has_many :projects, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :user
  has_many :milestones, dependent: :destroy, inverse_of: :user
  has_many :companies, through: :milestones
  has_many :user_skills, dependent: :destroy, inverse_of: :user
  has_many :skills, through: :user_skills
  has_many :user_roles, dependent: :destroy, inverse_of: :user
  has_many :roles, through: :user_roles
  belongs_to :location
  counter_culture :location, column_name: :users_count, touch: true

  # Nested
  accepts_nested_attributes_for :user_roles
  accepts_nested_attributes_for :user_skills, reject_if: :all_blank, allow_destroy: true

  # Validations
  validate  :username_not_in_routes
  validates :username, :uniqueness => { :case_sensitive => false },
            :format => { :with => /\A[\w\d\._-]+\Z/n,
            :message => "can only contain letters, numbers, underscores, dashes and dots" },
            :length => { :in => 0..50 }, allow_blank: true
  validates_size_of :avatar, maximum: 5.megabytes
  validates :website_url, url: { allow_blank: true }
  validates :twitter_url, url: { allow_blank: true }
  validates :dribbble_url, url: { allow_blank: true }
  validates :github_url, url: { allow_blank: true }
  validates :medium_url, url: { allow_blank: true }
  validates :facebook_url, url: { allow_blank: true }

  def onboarded?
    username.present? && location.present?
  end

  def is_hiring_name
    return "hiring" if is_hiring
  end

  def is_available_name
    return "available" if is_available
  end

  def remote_name
    return "remote" if open_to_remote
  end

  def location_name
    return location.name if location.present?
  end

  def skill_names
    self.skills.pluck(:name).join(" ")
  end

  def role_names
    self.roles.pluck(:name).join(" ")
  end

  def available_skills
    Skill.where.not(id: self.skills.pluck(:id))
  end

  def available_roles
    Role.where.not(id: self.roles.pluck(:id))
  end

  def display_name
    return name if name.present?
    return username
  end

  def update_years_experience
    value = [user_skills.maximum(:years),0].compact.max
    self.update_attributes(years_experience: value)
  end

  def has_facebook?
    authentications.facebook.any?
  end

  def facebook_client
    Koala::Facebook::API.new(get_fb_token)
  end

  def get_fb_token
    token = self.authentications.facebook.first.token if has_facebook?
  end
  
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
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

    user.import_facebook_omniauth(omniauth)

    return user
  end

  def import_facebook_omniauth(omniauth)
    return if omniauth["provider"] != "facebook"
    
    self.email = omniauth["info"]["email"] if !omniauth["info"]["email"].blank? && self.email.blank?
    self.name = omniauth["info"]["name"] if !omniauth["info"]["name"].blank? && self.name.blank?
    self.username = omniauth["info"]["nickname"] if !omniauth["info"]["nickname"].blank? && self.username.blank?

    # self.description = omniauth["info"]["description"] if !omniauth["info"]["description"].blank? && self.description.blank?
    # self.location = omniauth["info"]["location"] if !omniauth["info"]["location"].blank? && self.location.blank?

    if self.avatar.nil?
      image_url = omniauth["info"]["image"]
      self.avatar_url = image_url
    end

    # self.website = omniauth["extra"]["raw_info"]["website"] if !omniauth["extra"]["raw_info"]["website"].blank? && self.website.blank?
    self.gender = omniauth["extra"]["raw_info"]["gender"] if !omniauth["extra"]["raw_info"]["gender"].blank? && self.gender.blank?

    self.save

    return self
  end



  def username_not_in_routes
    if RouteRecognizer.new.initial_path_segments.include?(username)
      errors.add(:username, "not available")
    end
  end
end
