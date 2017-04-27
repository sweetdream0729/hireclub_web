class ReviewRequest < ApplicationRecord
  # Extensions
  include UnpublishableActivity
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }

  # Associations
  belongs_to :user

  # Validations
  validates :user, presence: true
  validates_length_of :goal, minimum: 10

  def status
    "Waiting for Review"
  end
end
