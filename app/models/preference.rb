class Preference < ApplicationRecord
  belongs_to :user

  # Validations
  validates :user, presence: true, uniqueness: true
end
