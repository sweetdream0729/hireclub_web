class Comment < ApplicationRecord
  # Extensions
  auto_strip_attributes :text, :squish => true
  nilify_blanks
  include UnpublishableActivity
  include ActsAsLikeable
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }

  # Scopes
  scope :by_recent, -> {order(created_at: :desc)}
  scope :by_oldest, -> {order(created_at: :asc)}

  # Associations
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  # Validations
  validates :user, presence: true
  validates :commentable, presence: true
  validates :text, presence: true
end
