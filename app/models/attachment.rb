class Attachment < ApplicationRecord
  # Extensions
  include HasSmartUrl
  has_smart_url :link
  dragonfly_accessor :file

  # Scopes
  scope :by_oldest, -> {order(created_at: :asc)}

  # Associations
  belongs_to :attachable, polymorphic: true

  # Validations
  validates :attachable, presence: true
  validate :link_or_file_present

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
