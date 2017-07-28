class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true, :null => false

      t.timestamp :canceled_at
      t.string :stripe_subscription_id
      t.string :status
      t.integer :price_cents, :null => false, :default => 0
      t.string :stripe_plan_id
      t.string :stripe_plan_name
      t.integer :card_id
      t.timestamp :current_period_end

      t.timestamps
    end

    add_index :subscriptions, :stripe_subscription_id, unique: true
    add_index :subscriptions, :stripe_plan_id 
    add_index :subscriptions, :stripe_plan_name
  end
end
