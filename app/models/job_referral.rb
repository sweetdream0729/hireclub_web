class JobReferral < ApplicationRecord
  extend FriendlyId
  include PublicActivity::Model
  include PublicActivity::CreateActivityOnce
  
  friendly_id :slug_candidates, use: :slugged
  tracked only: [:create], owner: Proc.new{ |controller, model| model.sender }

  # Associations
  belongs_to :sender, class_name: 'User'
  belongs_to :user
  belongs_to :job

  def slug_candidates
    [
      [:job_id, :id]
    ]
  end

  def self.refer_user(sender, user, job)
  	JobReferral.where(sender_id: sender, user_id: user, job_id: job).first_or_create!
  end
end
