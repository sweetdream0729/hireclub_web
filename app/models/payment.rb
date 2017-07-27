class Payment < ApplicationRecord
  
  belongs_to :payable, polymorphic: true

  # Validations
  validates :payable, presence: true
  validates :processor, presence: true
  validates :external_id, presence: true
  validates :amount_cents, presence: true
  validates :paid_on, presence: true
  validates_uniqueness_of :external_id, scope: :processor
end
