class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  validates :user, presence: true
  validates :skill, presence: true
  validates :skill_id, uniqueness: { scope: :user_id }
  validates :years, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
