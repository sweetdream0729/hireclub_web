class UserRole < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :role
  delegate :name, to: :role
  
  # Extensions
  counter_culture :role, column_name: :users_count
  acts_as_list scope: :user, top_of_list: 0

  # Validations
  validates :user, presence: true
  validates :role, presence: true
  validates :role_id, uniqueness: { scope: :user_id }
end
