class Company < ApplicationRecord
  # Extensions
  #include Admin::SkillAdmin
  include Searchable
  extend FriendlyId
  friendly_id :name, use: :slugged
  dragonfly_accessor :avatar
  dragonfly_accessor :logo

  # Scopes
  scope :by_name, -> { order('name ASC') }

  # Associations
  #has_many :user_skills, dependent: :destroy
  #has_many :users, through: :user_skills

  # Validations
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :slug, presence: true, uniqueness: {case_sensitive: false}
  validates :website_url,   url: { allow_blank: true }
  validates :twitter_url,   url: { allow_blank: true }
  validates :instagram_url, url: { allow_blank: true }
  validates :facebook_url,  url: { allow_blank: true }
  validates :angellist_url, url: { allow_blank: true }


end
