class FeedController < ApplicationController
  def index
    @activities = PublicActivity::Activity.all.page(params[:page])
  end
end
