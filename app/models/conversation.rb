class Conversation < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :slug

  # Associations
  has_many :conversation_users, dependent: :destroy
  has_many :users, through: :conversation_users

  # Validations
  validates :slug, :uniqueness => true, :presence => true
  validates :key, uniqueness: {case_sensitive: false}, :allow_blank => true
  
  # Callbacks
  before_validation :ensure_slug, on: :create
  before_validation :update_key
  
  def ensure_slug
    if slug.blank?
      self.slug = loop do
        slug = SecureRandom.hex(8)
        break slug unless Conversation.where(slug: slug).exists?
      end
    end
  end

  def update_key
    self.key = Conversation.key_for_users(self.users)
  end

  def self.key_for_users(users)
    users.sort.map(&:id).join("_")
  end

  def self.between(users)
    key = self.key_for_users(users)

    conversation = Conversation.where(key: key).first_or_create
    conversation.users = users
    conversation.save
    return conversation
  end
end
