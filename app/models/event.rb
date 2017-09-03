class Event < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  auto_strip_attributes :name, squish: true
  include HasSmartUrl
  has_smart_url :source_url
  dragonfly_accessor :image

  # Scope
  scope :by_start_time,  -> { order(start_time: :asc) }
  scope :by_recent,      -> { order(start_time: :desc) }
  scope :upcoming,       -> { where('events.start_time > ?', (Time.current.hour < 4 ? Time.current.yesterday : Time.current).beginning_of_day) }
  scope :past,           -> { where("events.start_time <= ?",Time.current)}

  # Associations
  belongs_to :user

  # Validations
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: {case_sensitive: false}
  validates :start_time, presence: true
  validates :source_url, presence: true
end
