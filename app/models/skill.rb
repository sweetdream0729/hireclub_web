class Skill < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Associations
  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills

  # Validations
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :slug, presence: true, uniqueness: {case_sensitive: false}
end
