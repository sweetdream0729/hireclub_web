class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.integer :amount_cents, null: false
      t.string :processor, null: false
      t.string :external_id, null: false
      t.references :payable, polymorphic: true, index: true, null: false
      t.timestamps
    end
  end
end
