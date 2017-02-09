class UserSkill < ApplicationRecord
  # Extensions
  include Wisper::Publisher
  counter_culture :skill, column_name: :users_count, touch: true
  acts_as_list scope: :user, top_of_list: 0
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }

  # Scopes
  scope :by_position, -> { order(position: :asc) }
  scope :by_longest,  -> { order(years: :desc) }

  # Associations
  belongs_to :user
  belongs_to :skill
  delegate :name, to: :skill
  
  # Validations
  validates :user, presence: true
  validates :skill, presence: true
  validates :skill_id, uniqueness: { scope: :user_id }
  validates :years, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Broadcasts
  after_initialize :subscribe_listeners
  after_commit     :broadcast_update
  after_destroy    :broadcast_update

  def subscribe_listeners
    self.subscribe(UserSkillListener.new)
  end

  def broadcast_update
    broadcast(:update_user_skill, self)
  end
end
