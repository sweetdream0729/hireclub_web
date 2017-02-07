class UserSkill < ApplicationRecord
  # Scopes
  scope :by_position, -> { order(position: :asc) }
  scope :by_longest,  -> { order(years: :desc) }

  # Associations
  belongs_to :user
  belongs_to :skill
  delegate :name, to: :skill
  
  # Extensions
  counter_culture :skill, column_name: :users_count
  counter_culture :user, column_name: :years_experience, delta_column: :years
  acts_as_list scope: :user, top_of_list: 0

  # Validations
  validates :user, presence: true
  validates :skill, presence: true
  validates :skill_id, uniqueness: { scope: :user_id }
  validates :years, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
