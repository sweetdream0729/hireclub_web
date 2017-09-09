class AddIndexToPayout < ActiveRecord::Migration[5.0]
  def change
  	add_index :payouts, [:stripe_charge_id, :provider_id, :payoutable_type, :payoutable_id], unique: true, name: "index_payouts_on_charge"
  end
end
