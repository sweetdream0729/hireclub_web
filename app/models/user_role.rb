class UserRole < ApplicationRecord
  # Extensions
  counter_culture :role, column_name: :users_count
  acts_as_list scope: :user, top_of_list: 0

  # Scopes
  scope :by_position, -> { order(position: :asc) }

  # Associations
  belongs_to :user
  belongs_to :role
  delegate :name, to: :role
  
  # Validations
  validates :user, presence: true
  validates :role, presence: true
  validates :role_id, uniqueness: { scope: :user_id }
end
