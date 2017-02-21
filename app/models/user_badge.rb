class UserBadge < ApplicationRecord
  # Extensions
  include UnpublishableActivity
  include Wisper::Publisher
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }

  # Associations
  belongs_to :user
  belongs_to :badge

  # Validations
  validates :user, presence: true
  validates :badge, presence: true
  validates :badge_id, uniqueness: { scope: :user_id }

  # Broadcasts
  after_initialize :subscribe_listeners
  after_commit     :broadcast_update
  after_destroy    :broadcast_update

  def subscribe_listeners
    #self.subscribe(UserSkillListener.new)
  end

  def broadcast_update
    broadcast(:update_user_badge, self)
  end
end
