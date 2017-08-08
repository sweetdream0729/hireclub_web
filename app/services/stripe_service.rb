class StripeService
  

  def self.process_charges from_date=nil, to_date=nil
    if from_date.nil?
      to_date = DateTime.now
      from_date = to_date - 25.hours
    end
    
    return false if from_date.nil? || to_date.nil?
    Stripe::Charge.list(limit: 100, 'created[gte]' => from_date.to_i, 'created[lte]' => to_date.to_i).auto_paging_each do |stripe_charge|
      begin
        Rails.logger.info puts stripe_charge
        payment = Payment.create_from_stripe_charge(stripe_charge)
        Rails.logger.info puts payment.inspect

        Rails.logger.info puts payment.errors.full_messages
      rescue Exception => e
        Rails.logger.error ("Could not update stripe charge #{stripe_charge.inspect} #{e}")
      end
    end

    return true
  end
  
  def self.process_cards
    users = User.has_stripe
    users.find_each do |user|
      cards = Stripe::Customer.retrieve(user.stripe_customer_id).sources.all(:object => "card")
      cards.data.each do |stripe_card|
        card = Card.create_or_update_card_from_stripe_card(user, stripe_card)
      end
      
    end
  end

end