class FeedController < ApplicationController
  def index
    @activities = Activity.only_public.published.public_display.by_recent.page(params[:page]).includes(:trackable, :owner)

    @placements = Placement.with_any_tags("home").in_time(DateTime.now).by_priority

    @user_completion = UserCompletion.new(current_user)

    @event = Event.published.upcoming.by_start_time.first
  end
end
