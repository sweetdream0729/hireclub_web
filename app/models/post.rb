class Post < ApplicationRecord
  is_impressionable
  include UnpublishableActivity
  include ActsAsMentionable

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

  # # Callbacks
  after_commit :create_mentions, on: :create

  def create_mentions
    mentioned_users.find_each do |mentioned|
      Mention.where(user: mentioned, mentionable: self, sender: user).first_or_create
    end
  end

  def mentioned_users
    @mentioned_users ||= User.where(username: mentions_text(text))
  end

  def name
    text
  end
end
