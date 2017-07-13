class CommunityInvite < ApplicationRecord
  # Extensions
  include UnpublishableActivity
  include PublicActivity::Model
  include PublicActivity::CreateActivityOnce


  extend FriendlyId
  friendly_id :slug

  # Associations
  belongs_to :community
  belongs_to :sender, class_name: 'User'
  belongs_to :user

  # Validations
  validates_presence_of :community, :sender, :user
  validates :slug, uniqueness: true, presence: true
  validates_uniqueness_of :user_id, scope: [:community_id, :sender_id]
  validate :user_not_sender
  validate :user_not_member

  # Callbacks
  before_validation :ensure_slug, on: :create
  after_commit :send_activity, on: :create

  def send_activity
    self.create_activity_once :create, owner: sender, recipient: user, private: true
  end

  def ensure_slug
    if slug.blank?
      self.slug = loop do
        slug = SecureRandom.urlsafe_base64(6).tr('1+/=lIO0_-', 'pqrsxyz')
        break slug unless CommunityInvite.where(slug: slug).exists?
      end
    end
  end

  def user_not_sender
     if sender.present? && user.present? && sender == user
      errors.add(:user, "can't invite yourself.")
    end
  end

  def user_not_member
     if community.present? && user.present? && user.member_of_community?(community)
      errors.add(:user, "already a member.")
    end
  end
end
