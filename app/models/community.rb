class Community < ApplicationRecord
  # Extensions
  include Searchable
  extend FriendlyId
  friendly_id :name, use: :slugged
  dragonfly_accessor :avatar
  is_impressionable
  include UnpublishableActivity
  include PublicActivity::CreateActivityOnce
  include PublicActivity::Model



  # Scopes
  scope :by_members,   -> { order(members_count: :desc) }
  scope :recent,       -> { order(created_at: :desc) }
  scope :oldest,       -> { order(created_at: :asc) }
  scope :alphabetical, -> { order(name: :asc) }

  scope :created_between,      -> (start_date, end_date) { where("created_at BETWEEN ? and ?", start_date, end_date) }

  # Validations
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :slug, presence: true, uniqueness: {case_sensitive: false}
end
