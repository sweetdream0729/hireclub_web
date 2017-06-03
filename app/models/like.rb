class Like < ApplicationRecord
  # In order to make a Model Likeable, you must add a likes_count column
  # rails generate counter_culture Project likes_count
  include UnpublishableActivity
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }
  
  # Scopes
  scope :recent,       -> { order(created_at: :desc) }
  scope :created_between,      -> (start_date, end_date) { where("created_at BETWEEN ? and ?", start_date, end_date) }

  # Associations
  belongs_to :user
  belongs_to :likeable, polymorphic: true, counter_cache: true
  

  validates_presence_of :likeable_id
  validates_presence_of :likeable_type
  validates_presence_of :user_id
  validates :user_id, uniqueness: { scope: [:likeable_id, :likeable_type]}

  def likeable_name
    return likeable.name
  end
end
