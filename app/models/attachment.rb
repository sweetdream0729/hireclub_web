class Attachment < ApplicationRecord
  # Extensions
  include HasSmartUrl
  include UnpublishableActivity
  include PublicActivity::Model
  tracked only: [:create], private: true

  has_smart_url :link
  dragonfly_accessor :file
  
  # Scopes
  scope :by_oldest, -> {order(created_at: :asc)}

  # Associations
  belongs_to :attachable, polymorphic: true
  belongs_to :user

  # Validations
  validates :attachable, presence: true
  validates :user, presence: true
  validate :link_or_file_present
  validates_size_of :file, maximum: 10.megabytes

  def link_or_file_present
    if !has_file? && !has_link?
      errors.add(:base, "must have link or file")
    end
  end

  def has_link?
    link.present?
  end

  def has_file?
    file_uid.present?
  end

end
