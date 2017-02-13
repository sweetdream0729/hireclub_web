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
  validates :facebook_id, uniqueness: {allow_blank: true}
  validates :website_url,   url: { allow_blank: true }
  validates :twitter_url,   url: { allow_blank: true }
  validates :instagram_url, url: { allow_blank: true }
  validates :facebook_url,  url: { allow_blank: true }
  validates :angellist_url, url: { allow_blank: true }


  def website_url=(_link)
    u=URI.parse(_link)

    if (!u.scheme)
        link = "http://" + _link
    else
        link = _link
    end
    super(link)
  end

  def domain
    URI.parse(website_url).host.downcase if website_url.present?
  end

  def self.import_facebook_url(url)
    puts "url #{url}"
    client = FacebookService.get_client

    begin
      # fb_page = FacebookService.facebook_client.get_object(url, {"fields"=>"id,name,description,phone,website,location,cover"}) 
      fb_page = client.get_object('', {id: url, fields: "id,username,name,website,link,about,description,founded,location,phone,emails,cover"})
      puts fb_page.inspect
      facebook_id = fb_page["id"]
      name = fb_page["name"]
      slug = fb_page["username"]
      puts facebook_id,name,slug
      
      company = Company.where('lower(slug) = ? OR facebook_id = ?', slug.downcase, facebook_id).take

      if company.nil? 
        company = Company.create(name: name, slug: slug, facebook_id: facebook_id)
      end

      company.website_url = fb_page["website"] if company.website_url.nil? 
      company.facebook_url = fb_page["link"] if company.facebook_url.nil? 
      company.tagline = fb_page["about"] if company.tagline.nil? 
      
      company.save

      return company

    rescue Exception => e
      message = "Cound not import facebook page: #{url}" 
      puts message
    end
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
