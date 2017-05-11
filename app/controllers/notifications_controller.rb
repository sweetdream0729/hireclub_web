class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    scope = current_user.notifications.published.not_message_create.recent
    @notifications = scope.page(params[:page]).per(20)

    Notification.mark_as_read(scope.unread)
  end
end
