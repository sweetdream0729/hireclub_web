class FeedController < ApplicationController
  def index
    @activities = PublicActivity::Activity.order(created_at: :desc).page(params[:page])
  end
end
