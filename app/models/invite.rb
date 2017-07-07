class Invite < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :slug, use: [:finders]
  is_impressionable
  auto_strip_attributes :text, :squish => true
  auto_strip_attributes :input, :squish => true
  nilify_blanks

  # Scopes
  scope :created_between,      -> (start_date, end_date) { where("created_at BETWEEN ? and ?", start_date, end_date) }

  include UnpublishableActivity
  include PublicActivity::Model
  include PublicActivity::CreateActivityOnce
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true

  # Associations
  belongs_to :user
  belongs_to :contact
  belongs_to :viewed_by, class_name: "User"
  belongs_to :recipient, class_name: "User"

  # Validations
  validates :user, presence: true
  validates :slug, uniqueness: true, presence: true

  validates :input, presence: true
  # require all contacts to be email right now
  validates_format_of :input, with: Devise.email_regexp, message: "Not a valid email."

  # Callbacks
  before_validation :ensure_slug, on: :create
  before_validation :set_recipient, on: :create

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
      self.create_activity_once key: InviteFirstViewActivity::KEY, owner: other_user, published: true, private: true, recipient: self.user
    end
  end

  def mark_bounced!
    self.create_activity_once key: InviteBounceActivity::KEY, owner: nil, published: true, private: true, recipient: self.user
  end

  def viewed?
    viewed_on.present?
  end

  def set_recipient
    self.recipient = User.where(email: input).first
    if self.recipient.nil?
      self.contact = Contact.where(email: input).first_or_create
    end
  end
end
