class CommunityMember < ApplicationRecord
  ADMIN = "admin"
  MODERATOR = "moderator"
  MEMBER = "member"

  ROLES = [
    ADMIN,
    MODERATOR,
    MEMBER
  ]

  # Scopes
  scope :admins,        -> { where(role: ADMIN) }
  scope :moderators,    -> { where(role: MODERATOR) }

  # Associations
  belongs_to :community
  counter_culture :community, column_name: "members_count"
  belongs_to :user

  # Validations
  validates :user, presence: true
  validates :community, presence: true
  validates :community_id, uniqueness: { scope: :user_id }
  validates :role, presence: true
  validates_inclusion_of :role, :in => ROLES

    # Callbacks
  after_create :create_join_activity
  after_destroy :create_leave_activity

  def create_join_activity
    community.create_activity_once :join, owner: user

    activities = community.activities.where(owner: user, key: CommunityJoinActivity::KEY)
    activities.update_all(published: true)
  end

  def create_leave_activity
    community.create_activity :leave, owner: user, published: false
    activities = community.activities.where(owner: user, key: CommunityJoinActivity::KEY)
    activities.update_all(published: false)
    notifications = Notification.where(activity_id: activities.pluck(:id))
    notifications.update_all(published: false)
    return true
  end

  def admin_or_moderator?
    role == MODERATOR || role == ADMIN
  end
end
