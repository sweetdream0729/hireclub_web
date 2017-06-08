class Placement < ApplicationRecord
  # Extensions
  acts_as_taggable_array_on :tags
  include HasTagsList
  has_tags_list :tags

  # Scopes
  scope :by_priority,    -> { order(priority: :asc) }
  scope :in_time,        ->(time) { where("placements.start_time <= ? and placements.end_time >= ?", time, time) }
  
  # Associations
  belongs_to :placeable, polymorphic: true

  # Validations
  validates :placeable, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate  :end_time_is_after_start_time


  protected
  def end_time_is_after_start_time
    if self.start_time.present? && self.end_time.present? && self.end_time < self.start_time
      errors.add(:end_time, "End Time must be after Start Time")
    end
  end
end
