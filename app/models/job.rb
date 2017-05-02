class Job < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  auto_strip_attributes :name, squish: true
  include HasSmartUrl
  has_smart_url :link
  is_impressionable

  # Scopes
  scope :recent,       -> { order(created_at: :desc) }

  # Associations
  belongs_to :company
  belongs_to :user

  # Validations
  validates :user, presence: true
  validates :company, presence: true
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
    return company.try(:name)
  end

end
