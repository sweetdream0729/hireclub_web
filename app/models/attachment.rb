class Attachment < ApplicationRecord
  # Extensions
  include HasSmartUrl
  has_smart_url :link
  dragonfly_accessor :file

  # Associations
  belongs_to :attachable, polymorphic: true

  # Validations
  validates :attachable, presence: true
  validate :link_or_file_present

  def link_or_file_present
    if link.blank? || file_uid.blank?
      errors.add(:base, "must have link or file")
    end
  end
end
