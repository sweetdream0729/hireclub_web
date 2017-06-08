class FeedController < ApplicationController
  def index
    @activities = Activity.only_public.published.public_display.by_recent.page(params[:page])

    @placements = Placement.with_any_tags("home").in_time(DateTime.now).by_priority
  end
end
