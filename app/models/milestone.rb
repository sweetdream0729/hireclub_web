class Milestone < ApplicationRecord
  # Scopes
  scope :by_oldest,     -> { order(start_date: :asc)}
  scope :by_newest,     -> { order(start_date: :desc)}

  # Associations
  belongs_to :user

  # Validations
  validates :title, presence: true
end
