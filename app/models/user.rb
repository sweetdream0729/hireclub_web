require 'route_recognizer'

class User < ApplicationRecord
  # Extensions
  include Admin::UserAdmin
  include PgSearch
  multisearchable :against => [:name, :username, :website_url, :skill_names, :role_names, :location_name, :is_hiring_name, :is_available_name, :remote_name]

  include UnpublishableActivity
  include Searchable
  include HasSmartUrl
  has_smart_url :website_url
  has_smart_url :twitter_url
  has_smart_url :dribbble_url
  has_smart_url :github_url
  has_smart_url :medium_url
  has_smart_url :facebook_url
  has_smart_url :instagram_url
  has_smart_url :linkedin_url
  has_smart_url :imdb_url

  acts_as_follower
  acts_as_followable
  extend FriendlyId
  friendly_id :username
  dragonfly_accessor :avatar
  is_impressionable
  include PublicActivity::CreateActivityOnce
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model }

  nilify_blanks

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook, :linkedin, :google_oauth2]

  # Scope
  scope :admin,        -> { where(is_admin: true) }
  scope :normal,       -> { where(is_admin: false) }
  scope :subscribers,  -> { where(is_subscriber: true) }
  scope :moderators,   -> { where(is_moderator: true) }
  scope :reviewers,    -> { where(is_reviewer: true) }
  scope :has_username, -> { where.not(username: nil) }
  scope :recent,       -> { order(created_at: :desc) }
  scope :oldest,       -> { order(created_at: :asc) }
  scope :alphabetical, -> { order(name: :asc) }
  scope :by_followers, -> { order(followers_count_cache: :desc) }
  scope :scoreable,    -> { confirmed.where.not(avatar_uid: nil)}
  scope :has_stripe,   -> { where.not(stripe_customer_id: nil)}
  scope :confirmed,    -> { where.not(confirmed_at: nil)}

  scope :email_newsletter, ->  { joins(:preference).merge(Preference.email_newsletter) }

  scope :created_between,      -> (start_date, end_date) { where("created_at BETWEEN ? and ?", start_date, end_date) }

  # Associations
  has_many :conversation_users, dependent: :destroy, inverse_of: :user
  has_many :conversations, through: :conversation_users
  has_many :review_requests, dependent: :destroy, inverse_of: :user
  has_many :notifications, dependent: :destroy, inverse_of: :user
  has_many :authentications, dependent: :destroy, inverse_of: :user
  has_many :projects, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :user
  has_many :milestones, dependent: :destroy, inverse_of: :user
  has_many :companies, through: :milestones
  has_many :user_skills, dependent: :destroy, inverse_of: :user
  has_many :skills, through: :user_skills
  has_many :user_roles, dependent: :destroy, inverse_of: :user
  has_many :roles, through: :user_roles
  has_many :user_badges, dependent: :destroy, inverse_of: :user
  has_many :badges, through: :user_badges
  has_many :resumes, dependent: :destroy, inverse_of: :user
  has_many :likes, dependent: :destroy, inverse_of: :user
  has_many :jobs, dependent: :destroy, inverse_of: :user
  has_many :stories, dependent: :destroy, inverse_of: :user
  has_many :events, dependent: :nullify, inverse_of: :user
  has_many :comments, dependent: :destroy, inverse_of: :user
  has_many :job_scores, dependent: :destroy, inverse_of: :user
  has_many :job_referrals, dependent: :destroy, inverse_of: :user
  has_many :invites, dependent: :destroy, inverse_of: :user
  has_many :messages, dependent: :destroy, inverse_of: :user
  has_many :analytics_events, dependent: :destroy, inverse_of: :user
  has_one :preference, dependent: :destroy, inverse_of: :user
  has_many :attachments, dependent: :destroy, inverse_of: :user
  has_one :provider, dependent: :destroy
  accepts_nested_attributes_for :preference

  belongs_to :location
  counter_culture :location, column_name: :users_count, touch: true

  belongs_to :company

  has_many :community_invites, dependent: :destroy, inverse_of: :user
  has_many :community_invites_sent, dependent: :destroy, inverse_of: :sender, class_name: "CommunityInvite", foreign_key: :sender_id
  has_many :community_members, inverse_of: :user, dependent: :destroy
  has_many :communities, through: :community_members
  has_many :posts, dependent: :destroy, inverse_of: :user
  has_many :mentions, dependent: :destroy, inverse_of: :user
  has_many :mentions_sent, dependent: :destroy, inverse_of: :sender, class_name: "Mention", foreign_key: :sender_id

  has_many :appointments, dependent: :destroy, inverse_of: :user
  has_many :appointments_completed, dependent: :nullify, inverse_of: :completed_by, class_name: "Appointment", foreign_key: :completed_by_id

  has_many :appointment_messages, dependent: :destroy, inverse_of: :user
  has_many :assignees, dependent: :destroy, inverse_of: :user
  has_many :assigned_appointments, through: :assignees, source: :appointment
  has_many :subscriptions, dependent: :destroy, inverse_of: :user
  has_many :payments, dependent: :nullify, inverse_of: :user
  has_many :cards, inverse_of: :user, dependent: :destroy
  has_many :email_list_members, inverse_of: :user, dependent: :destroy
  has_many :project_shares, dependent: :destroy, inverse_of: :user
  has_many :project_shares_received, inverse_of: :recipient, class_name: "ProjectShare", foreign_key: :recipient_id
  has_many :shared_projects, through: :project_shares_received, source: :project



  
  # Nested
  accepts_nested_attributes_for :user_roles
  accepts_nested_attributes_for :user_skills, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :milestones, reject_if: :all_blank, allow_destroy: true

  # Validations
  validate  :username_not_in_routes
  validates :username, :uniqueness => { :case_sensitive => false },
            :format => { :with => /\A[\w\d\._-]+\Z/n,
            :message => "can only contain letters, numbers, underscores, dashes and dots" },
            :length => { :in => 0..50 }, allow_blank: true
  validates_size_of :avatar, maximum: 5.megabytes
  validates :website_url, url: { allow_blank: true }
  validates :twitter_url, url: { allow_blank: true }
  validates :dribbble_url, url: { allow_blank: true }
  validates :github_url, url: { allow_blank: true }
  validates :medium_url, url: { allow_blank: true }
  validates :facebook_url, url: { allow_blank: true }
  validates :instagram_url, url: { allow_blank: true }
  validates :linkedin_url, url: { allow_blank: true }
  validates :imdb_url, url: { allow_blank: true }

  def onboarded?
    username.present? && location.present?
  end

  def is_hiring_name
    return "hiring" if is_hiring
  end

  def is_available_name
    return "available" if is_available
  end

  def remote_name
    return "remote" if open_to_remote
  end

  def location_name
    return location.name if location.present?
  end

  def skill_names
    self.skills.pluck(:name).join(" ")
  end

  def role_names
    self.roles.pluck(:name).join(" ")
  end

  def available_skills
    Skill.where.not(id: self.skills.pluck(:id))
  end

  def available_roles
    Role.where.not(id: self.roles.pluck(:id))
  end

  def display_name
    return name if name.present?
    return username
  end

  def short_display_name
    result = first_name
    result += " #{last_name[0]}." if !last_name.blank?
    return result
  end

  def first_name
    unless display_name.blank?
      split = [display_name.split[0]]
      split.empty? ? display_name : split.join(" ")
    end
  end

  def last_name
    unless display_name.blank?
      fragments = display_name.split.reject { |fragment| %(Jr. Jr Sr. Sr).include? fragment }
      if fragments.length == 1
        ""
      else
        # If the last fragment is a number, use all fragments but the first
        if fragments.last =~ /\d/
          fragments[1..fragments.length].join(' ')
        else
          fragments.last
        end
      end
    end
  end

  def update_years_experience
    value = [user_skills.maximum(:years),0].compact.max
    self.update_attributes(years_experience: value)
  end

  def blocked?(user)
    follow = get_follow_for(user)
    return false if follow.nil?
    return follow.blocked
  end

  def unblock(user)
    user.create_activity :unblock, owner: self
    super(user)
  end

  def has_facebook?
    authentications.facebook.any?
  end

  def has_linkedin?
    authentications.linkedin.any?
  end

  def facebook_client
    Koala::Facebook::API.new(get_fb_token)
  end

  def key_words
    self.user_roles.by_position.limit(3).map(&:name) + self.user_skills.by_position.limit(5).includes(:skill).map(&:name) + [ self.location.try(:name_and_parent) ]
  end


  def get_fb_token
    token = self.authentications.facebook.first.token if has_facebook?
  end

  def welcome!
    create_activity_once :welcome, owner: self, private: false
    EmailList.get_all_users.add_user(self)
  end

  def primary_role
    user_roles.by_position.first
  end

  def primary_role_name
    primary_role.try(:name)
  end

  def has_skill_name?(skill_name)
    skills.where(name: skill_name).any?
  end
  
  def display_notifications
    notifications.published.not_messages
  end

  def incomplete_appointments
    appointments.active.incomplete
  end

  def preference
    super || build_preference
  end

  def member_of_community?(community)
    CommunityMember.where(user: self, community: community).exists?
  end

  def join_community(community)
    cm = CommunityMember.where(user: self, community: community, role: CommunityMember::MEMBER).first_or_create
  end

  def leave_community(community)
    CommunityMember.where(user: self, community: community).destroy_all
  end

  def has_assignments?
    Assignee.where(user: self).exists?
  end

  # Devise methos
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def after_confirmation
    welcome!
  end

  def update_without_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def import_linkedin_omniauth(omniauth)
    return if omniauth["provider"] != "linkedin"
    if self.linkedin_url.blank? && omniauth['info']["urls"]["public_profile"].present?
      self.linkedin_url = omniauth['info']["urls"]["public_profile"]
    end
  end

  def import_facebook_omniauth(omniauth)
    return if omniauth["provider"] != "facebook"

    self.email = omniauth["info"]["email"] if !omniauth["info"]["email"].blank? && self.email.blank?
    self.name = omniauth["info"]["name"] if !omniauth["info"]["name"].blank? && self.name.blank?
    self.username = omniauth["info"]["nickname"] if !omniauth["info"]["nickname"].blank? && self.username.blank?

    # self.description = omniauth["info"]["description"] if !omniauth["info"]["description"].blank? && self.description.blank?

    city = "#{omniauth['info']['location']}"
    if city.present? && self.location.nil?
      prefix = city.split(",")[0]
      locations = Location.search_by_name(prefix)
      self.location = locations.first
    end

    if self.avatar.nil?
      image_url = omniauth["info"]["image"]
      self.avatar_url = image_url
    end

    # self.website = omniauth["extra"]["raw_info"]["website"] if !omniauth["extra"]["raw_info"]["website"].blank? && self.website.blank?
    self.gender = omniauth["extra"]["raw_info"]["gender"] if !omniauth["extra"]["raw_info"]["gender"].blank? && self.gender.blank?

    self.save

    ImportFacebookHistoryJob.perform_later(self, omniauth)

    return self
  end

  def import_google_omniauth(omniauth)
    return if omniauth["provider"] != Authentication::GOOGLE

    if self.avatar.nil?
      image_url = omniauth["extra"]["raw_info"]["picture"]
      self.avatar_url = image_url
    end

    self.gender = omniauth["extra"]["raw_info"]["gender"] if !omniauth["extra"]["raw_info"]["gender"].blank? && self.gender.blank?
    self.save

    return self
  end

  def import_work_from_facebook(work)
    return if work.blank?
    work.each do |item|
      Rails.logger.info puts item.inspect
      facebook_id = item["id"]
      milestone = Milestone.where(user: self, facebook_id: facebook_id).first_or_initialize
      milestone.description = item["description"] if milestone.description.blank?

      start_date = item["start_date"]
      if milestone.start_date.nil?
        if start_date.present?
          milestone.start_date = Chronic.parse(start_date)
        end

        milestone.start_date = Date.today if milestone.start_date.nil?
      end

      end_date = item["end_date"]
      if milestone.end_date.nil? && end_date.present?
        milestone.end_date = Chronic.parse(end_date)
      end

      if milestone.name.blank?
        company_name = item["employer"]["name"]
        milestone.name = "Joined #{company_name}"
        if item["position"].present?
          position = item["position"]["name"]
          milestone.name += " as #{position}" if position.present?
        end
      end

      company_facebook_id = item["employer"]["id"]

      if milestone.company.nil?
        begin
          company = Company.import_facebook_id(company_facebook_id)
          milestone.company = company
        rescue
          Rails.logger.info puts "could not import company #{company_facebook_id}"
        end
      end
      milestone.save
    end

    # {"description"=>"Untz Untz UntZ", "employer"=>{"id"=>"821365304544508", "name"=>"Up All Night SF"}, "location"=>{"id"=>"114952118516947", "name"=>"San Francisco, California"}, "position"=>{"id"=>"106275566077710", "name"=>"Chief technology officer"}, "start_date"=>"2014-09-30", "id"=>"10156584882275244"}

  end

  def import_education_from_facebook(education)
    return if education.blank?

    education.each do |item|
      type = item["type"]
      facebook_id = item["id"]
      Rails.logger.info puts item.inspect
      if (type == "College" || type == "Graduate School") && facebook_id.present?

        year = item["year"]["name"] if item["year"].present?
        school = item["school"]["name"] if item["school"].present?
        break if school.blank?

        milestone = Milestone.where(user: self, facebook_id: facebook_id).first_or_initialize
        milestone.start_date = Date.new(year.to_i) if milestone.start_date.nil? && year.present?
        milestone.start_date = Date.today if milestone.start_date.nil?
        milestone.kind = Milestone::EDUCATION

        milestone.name = "Went to #{school}" if milestone.name.blank?
        school_facebook_id = item["school"]["id"]

        if milestone.company.nil?
          begin
            company = Company.import_facebook_id(school_facebook_id)
            milestone.company = company
          rescue
            Rails.logger.info puts "could not import education company #{school_facebook_id}"
          end
        end

        milestone.save

      end
    end
  end

  def set_stripe_customer_id(value)
    return if value.nil?
    self.update_attribute(:stripe_customer_id, value)
  end

  def has_stripe_account?
    !stripe_customer_id.blank?
  end

  def is_provider?
    provider.present?
  end

  def username_not_in_routes
    if RouteRecognizer.new.initial_path_segments.include?(username)
      errors.add(:username, "not available")
    end
  end

  # Devise methods
  # Always remember user
  # https://github.com/plataformatec/devise/issues/1513
  def remember_me
    (super == nil) ? '1' : super
  end

  def display_email
    return unconfirmed_email if pending_reconfirmation?
    return email
  end

  def bio_count
    return bio.length if bio.present?
    0
  end

  def suggested_username
    if username.present?
      source = username
    elsif name.present?
      source = name
    elsif email.present?
      source = email.split("@")[0]
    else
      return nil
    end

    base = ActiveSupport::Inflector.parameterize(source, separator: '')
    suggested = base
    user_count = User.where(username: suggested).size
    count = 1
    while user_count > 0
      suggested = "#{base}#{count}"
      user_count = User.where(username: suggested).size
      count+=1
    end

    return suggested
  end

  # Class Methods
  def self.search_name_and_username(query)
    has_username.where("users.username ILIKE ? OR users.name ILIKE ?", "%#{query}%","%#{query}%")
  end

  def self.from_omniauth(omniauth, signed_in_resource=nil)
    # get auth model from omniauth data
    auth = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])

    if auth.present?
      # auth exists, update it
      user = auth.user
    elsif signed_in_resource
      # user exists, no auth exists
      user = signed_in_resource
      auth = user.authentications.build
    end

    if user.nil?
      email = omniauth["info"]["email"]
      # see if user exists with match auth email
      user = User.find_by_email(email)
      if user.nil?
        # user doesn't exist, create one
        user = User.create(:email => email, :password => Devise.friendly_token[0, 20], name: omniauth["info"]["name"])
      end
      auth = user.authentications.build
    end

    auth.from_omniauth(omniauth)
    auth.save

    user.import_facebook_omniauth(omniauth)
    user.import_linkedin_omniauth(omniauth)
    user.import_google_omniauth(omniauth)

    return user
  end

  # Access token for a user
  def preference_access_token(preference, value = false)
    User.create_access_token(self, preference, value)
  end

  # Verifier based on our application secret
  def self.verifier
    ActiveSupport::MessageVerifier.new(Rails.application.secrets.secret_key_base)
  end

  # Get a user from a token
  def self.read_access_token(signature)
    parameters = verifier.verify(signature)
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end

  # Class method for token generation
  def self.create_access_token(user, preference, value = false)
    verifier.generate({user_id: user.id, preference: preference, value: value})
  end

  def update_preference(preference_field, value)
    if preference_field == "unsubscribe_all"
      p = self.preference
      p.unsubscribe_all = true
      p.save
      create_activity :unsubscribe, owner: self, private: true, parameters: {preference: preference_field} 
    else
      preference.update_attribute(preference_field.to_sym , value)
      if value
        create_activity :resubscribe, owner: self, private: true, parameters: {preference: preference_field} 
      else
        create_activity :unsubscribe, owner: self, private: true, parameters: {preference: preference_field} 
      end
    end
  end

end
