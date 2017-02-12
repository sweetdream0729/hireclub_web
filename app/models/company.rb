class Company < ApplicationRecord
  # Extensions
  #include Admin::SkillAdmin
  include Searchable
  extend FriendlyId
  friendly_id :name, use: :slugged
  dragonfly_accessor :avatar
  dragonfly_accessor :logo

  # Scopes
  scope :by_name, -> { order(name: :asc) }

  # Associations
  #has_many :user_skills, dependent: :destroy
  #has_many :users, through: :user_skills

  # Validations
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :slug, presence: true, uniqueness: {case_sensitive: false}
  validates :website_url,   url: { allow_blank: true }
  validates :twitter_url,   url: { allow_blank: true }
  validates :instagram_url, url: { allow_blank: true }
  validates :facebook_url,  url: { allow_blank: true }
  validates :angellist_url, url: { allow_blank: true }


  def domain
    URI.parse(website_url).host.downcase if website_url.present?
  end

  def self.import
    file_name = "companies.json"
    path = File.join("#{Rails.root}/db/seeds/", "#{file_name}")
    return if !File.exist?(path)

    json = JSON.parse(open(path).read)
    json.each do |data|
      company = Company.where(:name => data["name"], :slug => data["slug"]).first_or_create

      company.twitter_url   = data["twitter_url"] if company.twitter_url.blank?
      company.facebook_url  = data["facebook_url"] if company.facebook_url.blank?
      company.instagram_url = data["instagram_url"] if company.instagram_url.blank?
      company.angellist_url = data["angellist_url"] if company.angellist_url.blank?
      company.website_url   = data["website_url"] if company.website_url.blank?
      company.tagline   = data["tagline"] if company.tagline.blank?
      # company.verified = data["verified"]
      # company.color = data["color"]
      
      company.save
    end
  end
end
