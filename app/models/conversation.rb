class Conversation < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :slug

  # Associations
  has_many :conversation_users, dependent: :destroy
  has_many :users, through: :conversation_users

  # Validations
  validates :slug, :uniqueness => true, :presence => true
  
  # Callbacks
  before_validation :ensure_slug, on: :create
  
  def ensure_slug
    if slug.blank?
      self.slug = loop do
        slug = SecureRandom.hex(8)
        break slug unless Conversation.where(slug: slug).exists?
      end
    end
  end
end
