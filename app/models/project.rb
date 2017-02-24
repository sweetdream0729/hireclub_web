class Project < ApplicationRecord
  # Extensions
  include Wisper::Publisher
  include UnpublishableActivity
  extend FriendlyId
  friendly_id :name, use: :slugged

  dragonfly_accessor :image
  is_impressionable
  
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }

  # Extensions
  acts_as_taggable_array_on :skills

  # Associations
  belongs_to :user

  # Validations
  validates :slug, uniqueness: { scope: :user_id, case_sensitive:false }
  validates_size_of :image, maximum: 5.megabytes
  validate :skills_exist

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
    name_changed?
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
  
end
