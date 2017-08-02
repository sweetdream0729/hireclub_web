class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.references :user, foreign_key: true, null: false
      t.string :stripe_card_id, null: false, index: true
      t.string :stripe_customer_id, null: false, index: true
      t.boolean :active, null: false, default: true, index: true
      t.boolean :deleted_on_stripe, null: false, default: false, index: true
      t.string :last4, null: false
      t.string :brand, null: false
      t.string :funding
      t.integer :exp_month
      t.integer :exp_year
      t.string :country
      t.string :name
      t.string :cvc_check
      t.boolean :is_default, null:false, default: false
      t.string :fingerprint

      t.timestamps
    end

    add_index :cards, [:user_id, :stripe_card_id], unique: true
    add_index :cards, [:user_id, :fingerprint], unique: true
  end
end
