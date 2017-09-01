class CreatePayouts < ActiveRecord::Migration[5.0]
  def change
    create_table :payouts do |t|
      t.references :provider, foreign_key: true, index: true, null: false
      t.references :payoutable, polymorphic: true, index: true, null: false
      t.integer :amount_cents, null: false
      t.string :stripe_charge_id, null: false
      t.datetime :transferred_on, index: true
      t.timestamps
    end
  end
end
