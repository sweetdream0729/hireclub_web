module Admin::PaymentAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      
      list do
        field :id
        field :amount
        field :user
        field :payable
        field :paid_on
        field :processor
        field :external_id
        field :description
        field :created_at
        field :updated_at
      end
    end
  end
end