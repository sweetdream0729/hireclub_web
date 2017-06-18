class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    scope = current_user.display_notifications.recent
    @notifications = scope.page(params[:page]).per(20).includes(activity: [:trackable, :owner])

    Notification.mark_as_read(scope.unread)
  end
end
