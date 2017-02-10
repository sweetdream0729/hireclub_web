class FeedController < ApplicationController
  def index
    @activities = Activity.published.by_recent.page(params[:page])
  end
end
