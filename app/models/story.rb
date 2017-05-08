class Story < ApplicationRecord
  # Extensions
  include UnpublishableActivity
  include ActsAsLikeable
  include Searchable
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  auto_strip_attributes :name, :squish => true
  is_impressionable

  include PublicActivity::Model
  include PublicActivity::CreateActivityOnce
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true

  # Scopes
  scope :published,       -> { where.not(published_on: nil) }
  scope :by_recent,       -> { order(published_on: :desc) }
  scope :by_oldest,       -> { order(published_on: :asc) }
  scope :by_popular,      -> { order(likes_count: :desc) }

  # Associations
  belongs_to :user
  belongs_to :company
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :user

  # Validations
  validates :user, presence: true
  validates :name, presence: true
  validates :slug, presence: true

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  def slug_candidates
    [
      [:name, :id]
    ]
  end

  def publish!
    unless published?
      self.published_on = DateTime.now
      self.save
      create_activity_once :publish, owner: self.user, private: false
    end
  end

  def published?
    published_on.present?
  end
end
