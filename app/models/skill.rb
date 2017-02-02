class Skill < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :slug, presence: true, uniqueness: {case_sensitive: false}
end
