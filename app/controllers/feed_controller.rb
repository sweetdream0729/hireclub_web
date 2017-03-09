class FeedController < ApplicationController
  def index
    @activities = Activity.only_public.published.by_recent.page(params[:page])
  end
end
