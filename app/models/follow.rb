class Follow < ActiveRecord::Base
  # Extensions
  include UnpublishableActivity
  include PublicActivity::CreateActivityOnce
  include PublicActivity::Model
  extend ActsAsFollower::FollowerLib
  extend ActsAsFollower::FollowScopes

  # NOTE: Follows belong to the "followable" and "follower" interface
  belongs_to :followable, polymorphic: true
  belongs_to :follower,   polymorphic: true

  # Callbacks
  after_create :create_follow_activity
  after_destroy :create_unfollow_activity

  def create_follow_activity
    followable.create_activity_once :follow, owner: follower
  end

  def create_unfollow_activity
    followable.create_activity :unfollow, owner: follower, published: false
  end

  def block!
    self.update_attribute(:blocked, true)
  end

end
