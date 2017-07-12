class Community < ApplicationRecord
  # Extensions
  include Searchable
  extend FriendlyId
  friendly_id :name, use: :slugged
  dragonfly_accessor :avatar
  is_impressionable
  include UnpublishableActivity
  include PublicActivity::CreateActivityOnce
  include PublicActivity::Model
  include PgSearch
  multisearchable :against => [:name]

  # Scopes
  scope :by_members,   -> { order(members_count: :desc) }
  scope :recent,       -> { order(created_at: :desc) }
  scope :oldest,       -> { order(created_at: :asc) }
  scope :alphabetical, -> { order(name: :asc) }
  scope :created_between,      -> (start_date, end_date) { where("created_at BETWEEN ? and ?", start_date, end_date) }

  # Associations
  has_many :posts, dependent: :destroy, inverse_of: :community
  has_many :community_members, dependent: :destroy, inverse_of: :community
  has_many :users, through: :community_members


  # Validations
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :slug, presence: true, uniqueness: {case_sensitive: false}


  def join_pending_invites(user)
    return unless user.present?
    return if user.member_of_community?(self)

    if CommunityInvite.where(user: user, community: self).any?
      user.join_community(self)
    end
  end
end

# https://cdn.trolleytours.com/wp-content/uploads/2016/06/washington-dc-capitol-at-night.jpg
# https://www.statuecruises.com/images/HSC-HomepageImage.jpg
# http://www.udr.com/uploadedImages/UDR3/Market_Areas/Common/UDR_3.0_SeattleWA.jpg
# https://tctechcrunch2011.files.wordpress.com/2015/02/chicago.jpg