class Assignee < ApplicationRecord

  include UnpublishableActivity
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true

  belongs_to :appointment
  counter_culture :appointment
  belongs_to :user

  validates :user, presence: true
  validates :appointment, presence: true
  validates :appointment_id, uniqueness: { case_sensitive: false, scope: :user_id }

end
