class Role < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Scopes
  scope :by_name, -> { order('name ASC') }

  # Associations
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  # Validations
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :slug, presence: true, uniqueness: {case_sensitive: false}


  def self.seed
    names = %w(Designer Developer Founder)
    names.each do |name|
      Role.where(name: name).first_or_create
    end    
  end
end
