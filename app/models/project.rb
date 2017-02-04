class Project < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :name, use: :slugged

  dragonfly_accessor :image

  # Associations
  belongs_to :user

  # Validations
  validates :slug, uniqueness: { scope: :user_id, case_sensitive:false }
  validates_size_of :image, maximum: 5.megabytes
end
