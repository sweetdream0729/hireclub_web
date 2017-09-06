class Event < ApplicationRecord
  # Extensions
  include UnpublishableActivity
  include PublicActivity::Model
  include PublicActivity::CreateActivityOnce

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  include HasSmartUrl
  has_smart_url :source_url

  dragonfly_accessor :image
  auto_strip_attributes :name, squish: true

  is_impressionable

  # Scope
  scope :published,      -> { where.not(published_on: nil) }
  scope :drafts,         -> { where(published_on: nil) }
  scope :by_start_time,  -> { order(start_time: :asc) }
  scope :by_recent,      -> { order(start_time: :desc) }
  scope :upcoming,       -> { where('events.start_time > ?', (Time.current.hour < 4 ? Time.current.yesterday : Time.current).beginning_of_day) }
  scope :past,           -> { where("events.start_time <= ?",Time.current)}

  # Associations
  belongs_to :user
  belongs_to :location

  # Validations
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: {case_sensitive: false}
  validates :start_time, presence: true
  validates :source_url, presence: true
  validates :location, presence: true
  validate  :end_time_is_after_start_time

  def should_generate_new_friendly_id?
    name_changed? || super
  end
  
  def publish!
    unless published?
      self.published_on = DateTime.now
      self.save
      create_activity_once :publish, owner: self.user, private: false if in_future?
    end
  end

  def published?
    published_on.present?
  end

  def unpublished?
    published_on.nil?
  end

  def in_future?
    self.start_time > Time.current
  end

  def end_time_is_after_start_time
    if self.start_time.present? && self.end_time.present? && self.end_time < self.start_time
      errors.add(:end_time, "End Time must be after Start Time")
    end
  end
end
