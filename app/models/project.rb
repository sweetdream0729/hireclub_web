class Project < ApplicationRecord
  # Extensions
  include Wisper::Publisher
  include UnpublishableActivity
  include ActsAsLikeable
  include FeedDisplayable
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  auto_strip_attributes :name, :squish => true
  auto_strip_attributes :link, :squish => true

  extend Dragonfly::Model::Validations
  dragonfly_accessor :image
  is_impressionable
  
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }

  acts_as_list scope: :user, top_of_list: 0
  acts_as_taggable_array_on :skills
  include HasTagsList
  has_tags_list :skills

  include HasSmartUrl
  has_smart_url :link

  include PgSearch
  multisearchable :against => [:name, :user_username, :user_display_name, :link, :skills_list, :company_name], if: :searchable?

  # Scopes
  scope :by_position,    -> { order(position: :asc) }
  scope :by_likes,       -> { order(likes_count: :desc) }
  scope :by_recent,      -> { order(created_at: :desc) }
  scope :by_oldest,      -> { order(created_at: :asc) }
  scope :with_image,     -> { where.not(image_uid: nil) }
  scope :without_image,  -> { where(image_uid: nil) }
  scope :by_user,        -> (user) { where(user: user) }
  scope :only_public,    -> { where(private: false) }
  scope :only_private,   -> { where(private: true) }

  scope :created_between,      -> (start_date, end_date) { where("created_at BETWEEN ? and ?", start_date, end_date) }

  # Associations
  belongs_to :user
  belongs_to :company
  has_many :project_shares, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :user

  # Validations
  validates :name, presence: true, length: { maximum: 64 }
  validates_presence_of :image
  validates :slug, uniqueness: { case_sensitive:false }
  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates_size_of :image, maximum: 5.megabytes
  validates_property :format, of: :image, in: ['jpeg', 'png', 'gif', 'jpg']

  validate :skills_exist
  # validates_property :width, of: :image, in: (400..10000)
  # validates_property :height, of: :image, in: (300..10000)

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
    name_changed? || super
  end

  def slug_candidates
    [
      [:name],
      [:name, :user_username]
    ]
  end

  def user_username
    user.username
  end

  def user_display_name
    user.display_name
  end

  def company_name
    company.try(:name)
  end

  def skills_exist
    skills.each do |name|
      if Skill.search_by_exact_name(name).empty?
        errors.add(:skills, "#{name} isn't a valid skill")
      end
    end
  end

  def key_words
    keywords = skills_list.split(", ")
    keywords << company.name if company.present?
    return keywords.join(", ")
  end

  def next_project(viewing_user = nil) 
    projects = Project.viewable_by(viewing_user, user).by_position
    index = projects.index(self)
    if index == nil
      projects = user.projects
      index = projects.index(self)
    end
    return projects[index + 1]
  end

  def previous_project(viewing_user = nil)
    projects = Project.viewable_by(viewing_user, user).by_position
    index = projects.index(self)
    if index == nil
      projects = user.projects
      index = projects.index(self)
    end
    return nil if index == 0
    return projects[index - 1]
  end

  def display_date
    return created_at if completed_on.nil?
    completed_on
  end

  def completed_on_formatted
    completed_on.strftime("%m/%d/%Y") if completed_on
  end

  def completed_on_formatted=(value)
    self.completed_on = Chronic.parse(value)
  end

  def searchable?
    !self.private
  end

  def self.viewable_by(viewing_user, user)
    if viewing_user != user
      return user.projects.only_public if viewing_user.nil?
      Rails.logger.info viewing_user.shared_projects.where(user: user).inspect
      user.projects.only_public + viewing_user.shared_projects.where(user: user)
    end
    return user.projects
  end
  
  def self.privatize_projects_without_image
    activities = Activity.only_public.where(key: "project.create")
    activities.find_each do |a|
      if a.trackable.present? && a.trackable.image.nil?
        a.private = true
        a.save
      end
    end

    activities = Activity.only_public.where(key: "like.create")
    activities.find_each do |a|
      if a.trackable.present? && a.trackable.likeable_type == "Project" && a.trackable.likeable.image.nil?
        a.private = true
        a.save
      end
    end
  end
end
