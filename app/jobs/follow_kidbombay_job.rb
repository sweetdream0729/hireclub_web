class FollowKidbombayJob < ApplicationJob
  queue_as :default

  def perform(user)
    kidbombay_user = User.find_by_username('kidbombay')
    kidbombay_user.follow user
  end
end
