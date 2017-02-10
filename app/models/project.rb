class Project < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :name, use: :slugged

  dragonfly_accessor :image
  
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }

  # Associations
  belongs_to :user

  # Validations
  validates :slug, uniqueness: { scope: :user_id, case_sensitive:false }
  validates_size_of :image, maximum: 5.megabytes

  def should_generate_new_friendly_id?
    name_changed?
  end
  
end
