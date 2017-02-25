class Activity < PublicActivity::Activity
  include Admin::ActivityAdmin

  scope :by_recent,    -> { order(created_at: :desc) }
  scope :unpublished,  -> { where(published: false) }
  scope :published,    -> { where(published: true) }
end

PublicActivity::Activity.class_eval do
  has_many :notifications, dependent: :destroy
  
end