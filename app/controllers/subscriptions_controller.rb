class SubscriptionsController < ApplicationController
  before_action :sign_up_required
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

  def cancel_subscription
  	@subscription = current_user.subscriptions.first
  end

  def cancel
    @subscription = current_user.subscriptions.first
    
    cancel_subscription = Subscription::CancelSubscription.new(current_user, @subscription, request, nil)
    @subscription = cancel_subscription.call
    
    respond_to do |format|
      format.html { redirect_to @subscription, notice: 'Subscription was successfully canceled.' }
      format.json { head :no_content }
    end
  end
end
