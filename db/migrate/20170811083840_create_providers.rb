class CreateProviders < ActiveRecord::Migration[5.0]
  def change
    create_table :providers do |t|
      t.references :user, foreign_key: true, index: true, :null => false
      t.string :stripe_account_id, unique: true
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.datetime :date_of_birth
      t.text :address_line_1
      t.text :address_line_2
      t.string :city
      t.string :state
      t.string :country
      t.string :postal_code
      t.string :ssn
      t.datetime :tos_acceptance_date
      t.string :tos_acceptance_ip
      t.boolean :charges_enabled, default: false
      t.boolean :payouts_enabled, default: false
      t.string :client_secret_key
      t.string :client_publishable_key
      t.string :verification_status

      t.timestamps
    end

    add_index :providers, :stripe_account_id, unique: true
  end
end
