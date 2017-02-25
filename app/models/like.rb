class Like < ApplicationRecord
  # In order to make a Model Likeable, you must add a likes_count column
  # rails generate counter_culture Project likes_count

  belongs_to :user
  belongs_to :likeable, polymorphic: true, counter_cache: true
  

  validates_presence_of :likeable_id
  validates_presence_of :likeable_type
  validates_presence_of :user_id
  validates :user_id, uniqueness: { scope: [:likeable_id, :likeable_type]}
end
