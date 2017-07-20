class Assignee < ApplicationRecord

  include UnpublishableActivity
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true

  belongs_to :appointment
  belongs_to :user

end
