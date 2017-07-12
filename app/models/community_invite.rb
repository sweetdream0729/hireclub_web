class CommunityInvite < ApplicationRecord
  # Extensions
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

  # Callbacks
  before_validation :ensure_slug, on: :create


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
end
