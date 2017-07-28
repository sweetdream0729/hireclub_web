class Payment < ApplicationRecord
  # Extensions
  monetize :amount_cents

  # Scopes
  scope :by_oldest, -> {order(created_at: :asc)}

  # Associations
  belongs_to :payable, polymorphic: true
  belongs_to :user

  # Validations
  validates :payable, presence: true
  validates :processor, presence: true
  validates :external_id, presence: true
  validates :amount_cents, presence: true
  validates :paid_on, presence: true
  validates_uniqueness_of :external_id, scope: :processor


  def amount_dollars=(value)
    value = value.gsub("$","").gsub(".","")
    self.amount_cents = value
  end
end
