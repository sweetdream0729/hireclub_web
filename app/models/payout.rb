class Payout < ApplicationRecord
  # Extensions
  include UnpublishableActivity
  include PublicActivity::CreateActivityOnce
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.provider.user }, private: true

  monetize :amount_cents

  # Associations
  belongs_to :provider
  belongs_to :payoutable, polymorphic: true

  # Validations
  validates :provider, presence: true
  validates :payoutable, presence: true
  validates :stripe_charge_id, presence: true
  validates :amount_cents, presence: true, numericality: { greater_than_or_equal_to: 1 }

  def transfer!
    return if transferred_on.present?

    begin
      stripe_charge = Stripe::Charge.retrieve(stripe_charge_id)
      if stripe_charge.present?
        create_transfer
      end
    rescue
      Rails.logger.warn(puts "Stripe Charge #{self.stripe_charge_id} not found")
    end
  end

  def create_transfer
    return if transferred_on.present?

    begin
      stripe_transfer = Stripe::Transfer.create({
        amount: amount_cents,
        currency: "usd",
        source_transaction: stripe_charge_id,
        destination: provider.stripe_account_id,
        metadata: {
          provider_id: provider.id,
          payoutable_id: payoutable_id,
          payoutable_type: payoutable_type
        }
      })

      Rails.logger.info(puts stripe_transfer.inspect)

      if stripe_transfer.present?
        self.stripe_transfer_id = stripe_transfer.id
        self.trasferred_on = DateTime.now
        self.save

        self.payoutable.paid_out!

        Rails.logger.info(puts self.inspect)
      end
      
    rescue
      Rails.logger.warn(puts "Could not create transfer for #{payout.id}")
    end

  end
end
