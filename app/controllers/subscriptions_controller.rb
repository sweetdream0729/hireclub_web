class SubscriptionsController < ApplicationController
  def new
    if current_user.is_subscriber && current_user.subscriptions.active.any?
      redirect_to current_user.subscriptions.active.last
    else
  	 @subscription = Subscription.new(user: current_user)
    end
  end

  def create
  	create_subscription = Subscription::CreateSubscription.new(current_user, params[:stripeToken], {}, request)
    @subscription = create_subscription.call
    if @subscription.is_active?
      redirect_to @subscription, notice: 'You are now a HireClub Hero!'
    else
      render :new
    end
  end

  def show
  	@subscription = Subscription.find(params[:id])
  end
end
