class Milestone < ApplicationRecord
  # Extensions
  include Wisper::Publisher
  include UnpublishableActivity
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }
  
  # Scopes
  scope :by_oldest,     -> { order(start_date: :asc)}
  scope :by_newest,     -> { order(start_date: :desc)}

  # Associations
  belongs_to :user
  belongs_to :company

  # Validations
  validates :title, presence: true

  # Broadcasts
  after_initialize :subscribe_listeners
  after_commit     :broadcast_update
  after_destroy    :broadcast_update

  def subscribe_listeners
    self.subscribe(MilestoneListener.new)
  end

  def broadcast_update
    broadcast(:update_milestone, self)
  end
end
