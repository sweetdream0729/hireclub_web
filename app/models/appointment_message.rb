class AppointmentMessage < ApplicationRecord
  include UnpublishableActivity
  include PublicActivity::CreateActivityOnce
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true
  nilify_blanks

  # Scopes
  scope :by_recent, -> {order(created_at: :desc)}
  scope :by_oldest, -> {order(created_at: :asc)}

  # Associations
  belongs_to :user
  belongs_to :appointment

  # Validations
  validates :user, presence: true
  validates :appointment, presence: true
  validates :text, presence: true
end
