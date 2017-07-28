class Subscription < ApplicationRecord
  # Extensions
	include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }
  monetize :price_cents

  # Constants
  PENDING = 'pending'
  ACTIVE = "active"
  CANCELED = "canceled"
  PAST_DUE = "past_due"
  TRIAL = "trialing"
  NONE = "none"

  STATUSES = [
    PENDING,
    ACTIVE,
    CANCELED,
    PAST_DUE
  ]
  
  # Scopes
  scope :active,            -> { where(status: ACTIVE) }
  scope :canceled,          -> { where(status: CANCELED) }
  scope :past_due,          -> { where(status: PAST_DUE) }
  scope :pending,           -> { where(status: PENDING) }
  scope :not_canceled,      -> { where.not(status: CANCELED) }
  scope :by_recent,         -> { order(created_at: :desc) }
  scope :by_oldest,         -> { order(created_at: :asc) }
  
  # Assocations
  belongs_to :user, inverse_of: :subscriptions

  # Validations
  validates :price_cents, :presence => true
  validates :user, :presence => true
  validates :status, presence: true, inclusion: { in: STATUSES }

  def name
    stripe_plan_name
  end

  def is_active?
    status == ACTIVE
  end

  def is_past_due?
    status == PAST_DUE
  end

  def is_canceled?
    status == CANCELED
  end

  def cancelable?
    is_active? || is_past_due?
  end

  def status_display
    return "#{stripe_plan_name} Active" if is_active?
    return "#{stripe_plan_name} Past Due" if is_past_due?
    return "#{stripe_plan_name} Canceled" if is_canceled?
  end

  def save_with_payment(card_token = nil)
    Subscription.transaction do
      # set price to zero until charge
      self.price_cents = 0
      plan = self.get_plan

      if valid?
        begin
          if !user.has_stripe_account?
            customer = Stripe::Customer.create(
              :source => card_token,
              :plan => plan["id"],
              :email => self.user.email
            )
            
            user.set_stripe_customer_id(customer.id)
            stripe_sub = customer.subscriptions.first
          else
            customer = Stripe::Customer.retrieve(user.stripe_customer_id)
            stripe_sub = customer.subscriptions.create(:plan => plan["id"], source: card_token)

            # Reload the customer in case card_token refers to a new credit card
            # This ensures that customer.sources is populated when called below
            customer = Stripe::Customer.retrieve(user.stripe_customer_id)
          end
        
          self.stripe_subscription_id = stripe_sub.id
          self.status = stripe_sub.status
          self.price_cents = stripe_sub.plan.amount
          self.stripe_plan_id = stripe_sub.plan.id
          self.stripe_plan_name = stripe_sub.plan.name

          if stripe_sub.current_period_end.present?
            self.current_period_end = Time.at(stripe_sub.current_period_end)
          end

          self.update_status(stripe_sub.status)
          
        rescue Stripe::CardError => card_error
          errors.add(:base, card_error.message)
          
          raise ActiveRecord::Rollback
        rescue Stripe::InvalidRequestError => request_error
          errors.add(:base, request_error.message)
          raise ActiveRecord::Rollback
        end
        
      end
    end
  end

  def get_plan
  	stripe_plans = Stripe::Plan.all
  	stripe_plans['data'][0]
  end

  def update_status(new_status)
    if new_status == Subscription::ACTIVE || new_status == Subscription::TRIAL
      self.set_active 
    elsif new_status == Subscription::PAST_DUE
      self.set_past_due 
    end
  end

  def set_role
    return unless is_active?
    user.is_subscriber = true
    user.save
  end

  def remove_role
    user.is_subscriber = true
    user.save
  end

  def set_active
    self.update_attribute(:status, ACTIVE)
    self.set_role
    # self.user.set_past_due(false)
  end

  def set_past_due
    if status != PAST_DUE
      self.update_attribute(:status, PAST_DUE)
      # self.remove_user_from_group
      # self.user.set_past_due(true)

      # SlackNotifierService.subscription_past_due(self)
      # SubscriptionMailer.delay.subscription_past_due(self)
      # SendSonarService.send_past_due_message(self.id)
    end
  end

  def cancel(reason=nil)
    return if is_canceled?
    customer = Stripe::Customer.retrieve(self.user.stripe_customer_id)
    begin
      # handle if stripe_subscription_id is not found
      stripe_sub = customer.subscriptions.retrieve(self.stripe_subscription_id).delete
    rescue
      Rails.logger.info "Stripe subscription #{self.stripe_subscription_id} not found"
    end
    
    self.update_attribute(:status, CANCELED)
    self.update_attribute(:canceled_at, DateTime.now)
    
  end


  def self.start(user, card_token, params = nil)
    # Cancel any active subscriptions
    # existing_subs = user.subscriptions.active
    # existing_subs.each do |sub|
    #   sub.cancel
    # end
    subscription = user.subscriptions.first
    if subscription.nil?
	    subscription = user.subscriptions.build(status: PENDING)
	    subscription.update_attributes(params) if params.present?

	    subscription.save_with_payment(card_token)
		end

    return subscription
  end
end
