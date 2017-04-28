class Project < ApplicationRecord
  # Extensions
  include Wisper::Publisher
  include UnpublishableActivity
  include ActsAsLikeable
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  auto_strip_attributes :name, :squish => true
  auto_strip_attributes :link, :squish => true

  dragonfly_accessor :image
  is_impressionable
  
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }

  acts_as_list scope: :user, top_of_list: 0

  # Scopes
  scope :by_position, -> { order(position: :asc) }
  scope :by_recent,   -> { order(created_at: :desc) }
  scope :with_image,  -> { where.not(image_uid: nil) }

  # Extensions
  acts_as_taggable_array_on :skills

  # Associations
  belongs_to :user
  belongs_to :company
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :user

  # Validations
  validates :name, presence: true
  validates :slug, uniqueness: { case_sensitive:false }
  validates_size_of :image, maximum: 5.megabytes
  validates_property :format, of: :image, in: ['jpeg', 'png', 'gif', 'jpg']
  validate :skills_exist
  validates_property :width, of: :image, in: (400..10000)
  validates_property :height, of: :image, in: (300..10000)

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
      [:name, :id]
    ]
  end

  def skills_list=(string)
    self.skills = string.split(",").map!(&:strip)
  end

  def skills_list
    self.skills.join(", ")
  end

  def skills_exist
    skills.each do |name|
      if Skill.where('name ilike ?', name).empty?
        errors.add(:skills, "#{name} isn't a valid skill")
      end
    end
  end

  def key_words
    keywords = skills_list.split(", ")
    keywords << company.name if company.present?
    return keywords.join(", ")
  end

  def next_project 
    projects = user.projects.by_position
    index = projects.index(self)
    return projects[index + 1]
  end

  def previous_project
    projects = user.projects.by_position
    index = projects.index(self)
    return nil if index == 0
    return projects[index - 1]
  end
  
end
