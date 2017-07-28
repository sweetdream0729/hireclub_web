class AddUserIdToPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :user_id, :integer, index: true
  end
end
