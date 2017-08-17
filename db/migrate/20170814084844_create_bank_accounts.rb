class CreateBankAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_accounts do |t|
      t.references :provider, foreign_key: true, index: true, :null => false
      t.string :stripe_bank_account_id, unique: true
      t.string :bank_name
      t.string :holder_name
      t.string :account_number
      t.string :routing_number
      t.string :country
      t.string :fingerprint, unique: true

      t.timestamps
    end

    add_index :bank_accounts, :stripe_bank_account_id, unique: true
  end
end
