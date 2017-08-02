class AddProcessorFeeCentsToPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :processor_fee_cents, :integer, null: false, default: 0
  end
end
