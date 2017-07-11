class Post < ApplicationRecord
  is_impressionable
  include UnpublishableActivity
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }

  # Scopes
  scope :recent,       -> { order(created_at: :desc) }

  belongs_to :user
  belongs_to :community
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :user

  # Validations
  validates :text, presence: true
  validates :user, presence: true
  validates :community, presence: true

  def name
    text
  end
end
