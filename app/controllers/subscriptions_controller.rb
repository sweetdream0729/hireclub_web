class SubscriptionsController < ApplicationController
  def new
  	@subscription = Subscription.new(user: current_user)
  end

  def create
  	create_subscription = Subscription::CreateSubscription.new(current_user, params[:stripeToken], {}, request)
    @subscription = create_subscription.call
    if @subscription.is_active?
      redirect_to @subscription, notice: 'You are subscribed to HireCLub Hero plan'
    else
      render :new
    end
  end

  def show
  	@subscription = Subscription.find(params[:id])
  end
end
