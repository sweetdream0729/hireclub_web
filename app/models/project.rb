class Project < ApplicationRecord
  # Extensions
  include Wisper::Publisher
  include UnpublishableActivity
  extend FriendlyId
  friendly_id :name, use: :slugged

  dragonfly_accessor :image
  is_impressionable
  
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }

  # Associations
  belongs_to :user

  # Validations
  validates :slug, uniqueness: { scope: :user_id, case_sensitive:false }
  validates_size_of :image, maximum: 5.megabytes

  # Broadcasts
  after_initialize :subscribe_listeners
  after_commit     :broadcast_update
  after_destroy    :broadcast_update

  def subscribe_listeners
    self.subscribe(ProjectListener.new)
  end

  def broadcast_update
    broadcast(:update_project, self)
  end

  def should_generate_new_friendly_id?
    name_changed?
  end
  
end
