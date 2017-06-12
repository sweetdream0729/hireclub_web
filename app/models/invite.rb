class Invite < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :viewed_by, class_name: "User"

  # Validations
  validates :user, presence: true
  validates :slug, uniqueness: true, presence: true

  validates :input, presence: true
  # require all contacts to be email right now
  validates_format_of :input, with: Devise.email_regexp, message: "Not a valid email."

  # Extensions
  extend FriendlyId
  friendly_id :slug, use: [:finders]
  is_impressionable
  auto_strip_attributes :text, :squish => true
  auto_strip_attributes :input, :squish => true
  nilify_blanks

  include UnpublishableActivity
  include PublicActivity::Model
  include PublicActivity::CreateActivityOnce
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true

  # Callbacks
  before_validation :ensure_slug, on: :create

  def ensure_slug
    if slug.blank?
      self.slug = loop do
        slug = SecureRandom.urlsafe_base64(6).tr('1+/=lIO0_-', 'pqrsxyz')
        break slug unless Invite.where(slug: slug).exists?
      end
    end
  end

  def mark_viewed!(other_user)
    if other_user != self.user && !viewed?
      self.viewed_on = DateTime.now
      self.viewed_by = other_user
      self.save
    end
  end

  def viewed?
    viewed_on.present?
  end
end
