class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    scope = current_user.notifications.published.recent
    @notifications = scope.page(params[:page]).per(10)
  end
end
