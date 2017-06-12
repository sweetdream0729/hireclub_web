class Contact < ApplicationRecord
  # Extensions
  auto_strip_attributes :email, :squish => true

  # Associations
  has_many :invites

  # Validations
  validates :email, uniqueness: { case_sensitive: false }, presence: true
  validates_format_of :email, with: Devise.email_regexp, message: "Not a valid email"
end
