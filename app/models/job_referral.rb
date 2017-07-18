class JobReferral < ApplicationRecord
  extend FriendlyId
  include PublicActivity::Model
  include PublicActivity::CreateActivityOnce
  
  friendly_id :slug, use: [:finders]
  tracked only: [:create], owner: Proc.new{ |controller, model| model.sender }

  # Associations
  belongs_to :sender, class_name: 'User'
  belongs_to :user
  belongs_to :job

  # Validations
  validates :user, presence: true
  validates :sender, presence: true
  validates :job, presence: true
  validates :slug, uniqueness: true, presence: true

  # Callbacks
  before_validation :ensure_slug, on: :create

  def ensure_slug
    if slug.blank?
      self.slug = loop do
        slug = SecureRandom.urlsafe_base64(6).tr('1+/=lIO0_-', 'pqrsxyz')
        break slug unless JobReferral.where(slug: slug).exists?
      end
    end
  end

  def self.refer_user(sender, user, job)
  	JobReferral.where(sender_id: sender, user_id: user, job_id: job).first_or_create!
  end
end
