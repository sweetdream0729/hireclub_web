class Job < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  auto_strip_attributes :name, squish: true
  include HasSmartUrl
  has_smart_url :link
  is_impressionable

  include UnpublishableActivity
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }

  include PgSearch
  multisearchable :against => [:name, :company_name, :location_name, :full_time_name, :part_time_name, :remote_name, :contract_name, :internship_name]

  # Scopes
  scope :recent,       -> { order(created_at: :desc) }

  # Associations
  belongs_to :company
  belongs_to :user
  belongs_to :location

  # Validations
  validates :user, presence: true
  validates :company, presence: true
  validates :location, presence: true
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: {case_sensitive: false}
  validates :description, presence: true
  
  def should_generate_new_friendly_id?
    name_changed? || super
  end

  def slug_candidates
    [
      [:name, :company_name, :id]
    ]
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

end
