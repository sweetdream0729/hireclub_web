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
        #Charge.create_from_stripe_charge(stripe_charge)
      rescue Exception => e
        Rails.logger.error ("Could not update stripe charge #{stripe_charge.inspect} #{e}")
      end
    end

    return true
  end
  
end