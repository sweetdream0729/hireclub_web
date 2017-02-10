class Milestone < ApplicationRecord
  # Extensions
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }
  
  # Scopes
  scope :by_oldest,     -> { order(start_date: :asc)}
  scope :by_newest,     -> { order(start_date: :desc)}

  # Associations
  belongs_to :user

  # Validations
  validates :title, presence: true
end
