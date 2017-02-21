class Badge < ApplicationRecord
  include Searchable
  extend FriendlyId
  friendly_id :name, use: :slugged
  dragonfly_accessor :avatar

  # Scopes
  scope :by_name, -> { order('name ASC') }
  scope :by_position, -> { order(position: :asc) }

  # Associations
  has_many :user_badges, dependent: :destroy
  has_many :users, through: :user_badges

  # Validations
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :slug, presence: true, uniqueness: {case_sensitive: false}

  def self.reward_og_badge(user)
    badge = Badge.where(name: "Original Gangsta").first
    Badge.reward(user, badge)
  end

  def self.reward_skill_badge(user)
    badge = Badge.where(name: "Skillz").first
    Badge.reward(user, badge)
  end

  def self.reward_milestone_badge(user)
    badge = Badge.where(name: "Milestoned").first
    Badge.reward(user, badge)
  end

  def self.reward_milehigh_badge(user)
    badge = Badge.where(name: "Mile High Club").first
    Badge.reward(user, badge)
  end

  def self.reward(user, badge)
    user_badge = UserBadge.where(user: user, badge: badge).first_or_create
  end

  def self.seed
    badge = Badge.where(name: "Original Gangsta").first_or_create
    badge.update_attributes(
      description: "Original HireClub group member.",
      earned_by: "being part of HireClub group before launch."
    )

    badge = Badge.where(name: "Skillz").first_or_create
    badge.update_attributes(
      description: "Skillz to pay the bills.",
      earned_by: "adding 5 skills."
    )

    badge = Badge.where(name: "Milestoned").first_or_create
    badge.update_attributes(
      description: "You are going places kid.",
      earned_by: "adding 5 milestones."
    )

    badge = Badge.where(name: "Mile High Club").first_or_create
    badge.update_attributes(
      description: "Nothin gonna stop us now.",
      earned_by: "adding 10 milestones."
    )
  end

end
