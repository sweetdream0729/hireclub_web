class Job < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]
  auto_strip_attributes :name, squish: true
  include HasSmartUrl
  include ActsAsLikeable
  include FeedDisplayable
  has_smart_url :link
  is_impressionable

  include UnpublishableActivity
  include PublicActivity::Model
  include PublicActivity::CreateActivityOnce
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true

  include PgSearch
  multisearchable :against => [:name, :skills_list, :user_display_name, :user_username, :company_name, :location_name, :full_time_name, :part_time_name, :remote_name, :contract_name, :internship_name]

  acts_as_taggable_array_on :skills
  include HasTagsList
  has_tags_list :skills

  # Scopes
  scope :recent,          -> { order(created_at: :desc) }
  scope :published,       -> { where.not(published_on: nil) }
  scope :drafts,          -> { where(published_on: nil) }

  scope :created_between,      -> (start_date, end_date) { where("created_at BETWEEN ? and ?", start_date, end_date) }
  scope :published_between,    -> (start_date, end_date) { where("published_on BETWEEN ? and ?", start_date, end_date) }

  # Associations
  belongs_to :company
  belongs_to :user
  belongs_to :role
  belongs_to :location
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :user
  has_many :job_scores, dependent: :destroy, inverse_of: :job
  has_many :job_referrals, dependent: :destroy

  # Validations
  validates :user, presence: true
  validates :company, presence: true
  validates :role, presence: true
  validates :location, presence: true
  validates :name, presence: true
  validates_length_of :name, minimum: 6, maximum: 50
  validates :slug, presence: true, uniqueness: {case_sensitive: false}
  validates :description, presence: true
  validate :skills_exist

  # Callbacks

  before_save :deduplicate_skills
  
  def should_generate_new_friendly_id?
    name_changed? || super
  end

  def slug_candidates
    [
      [:name, :company_name],
      [:name, :company_name, :company_jobs_count]
    ]
  end

  def company_jobs_count
    company.jobs.count + 1 if company.present?
  end

  def skills_exist
    skills.each do |name|
      if Skill.search_by_exact_name(name).empty?
        errors.add(:skills, "#{name} isn't a valid skill")
      end
    end
  end


  def user_display_name
    user.display_name
  end

  def user_username
    user.username
  end

  def company_name
    company.try(:name)
  end

  def location_name
    location.try(:display_name)
  end

  def full_time_name
    return "full time" if full_time
  end

  def part_time_name
    return "part time" if part_time
  end

  def remote_name
    return "remote" if remote
  end

  def contract_name
    return "contract" if contract
  end

  def internship_name
    return "internship" if internship
  end

  def publish!
    unless published?
      self.published_on = DateTime.now
      self.save
      create_activity_once :publish, owner: self.user, private: false
    end
  end

  def published?
    published_on.present?
  end

  def unpublished?
    published_on.nil? 
  end

  def any_flags?
    full_time || part_time || contract || internship || remote
  end

  def parse_suggested_skills
    results = TextService.find_keywords(description, Skill.all)
    return results
  end

  def update_suggested_skills!
    self.suggested_skills = parse_suggested_skills.map(&:name)
    self.save
  end

  def add_skill!(skill)
    if self.skills.include?(skill)
      return false
    end
    self.skills << skill
    self.save
    return true
  end

  def deduplicate_skills
    self.suggested_skills = self.suggested_skills - self.skills
  end

  def update_suggested_users
    User.scoreable.find_each do |user|
      job_score = self.job_scores.where(user: user).first_or_create
      job_score.update_score
    end
  end

  def suggested_job_scores
    job_scores.greater_than_zero.by_score.where('job_scores.user_id != ?', self.user_id).limit(5)
  end

  def referred_user(user)
    job_referrals.pluck(:user_id).include?(user.id)
  end
end
