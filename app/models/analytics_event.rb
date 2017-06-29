class AnalyticsEvent < ApplicationRecord
  # Extensions
  include Admin::AnalyticsEventAdmin
  include Wisper::Publisher

  # Scopes
  scope :created_between,      -> (start_date, end_date) { where("created_at BETWEEN ? and ?", start_date, end_date) }
  scope :searches,             -> { where(key: SearchActivity::KEY) }
  scope :email_deliveries,     -> { where(key: "email.delivery") }
  scope :email_opens,          -> { where(key: "email.open") }
  scope :email_clicks,         -> { where(key: "email.click") }

  # Associations
  belongs_to :user

  # Validations
  validates :event_id, :uniqueness => true, :presence => true
  validates :key, presence: true
  validates :timestamp, :presence => true

  # Callbacks
  before_save      :parse_user
  after_create     :broadcast_create
  
  def parse_user
    return if data.nil? || user.present?

    found_user_id ||= data["user_id"]
    if data["rcpt_meta"].present?
      found_user_id ||= data["rcpt_meta"]["user_id"]
    end

    email = data["raw_rcpt_to"]
    if found_user_id.nil? && email.present?
      found_user_id = User.where(email: email).or(User.where(unconfirmed_email: email)).pluck(:id).first
    end

    self.user = User.where(id: found_user_id.to_i).first
  end

  def broadcast_create
    self.subscribe(AnalyticsEventListener.new)
    broadcast(:create_analytics_event, self)
  end

  def self.create_search_event(params, user, request)
    key = SearchActivity::KEY
    event_id = self.generate_event_id
    timestamp = DateTime.now
    data = params

    if user.present?
      data[:user_id] = user.id.to_s
    end

    if request.present?
      data[:ip_address] = request.ip
      data[:user_agent] = request.user_agent
      data[:session_id] = request.session.id
    end
    self.create(event_id: event_id, key: key, timestamp: timestamp, data: data, user: user )
  end

  def self.generate_event_id
    event_id = loop do
      event_id = rand(999999999999999999)
      break event_id unless AnalyticsEvent.where(event_id: event_id).exists?
    end
    return event_id
  end
end
