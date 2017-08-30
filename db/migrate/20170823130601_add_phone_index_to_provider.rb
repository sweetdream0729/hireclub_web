class AddPhoneIndexToProvider < ActiveRecord::Migration[5.0]
  def change
    add_index :providers, :phone, unique: true
    add_index :providers, :ssn, unique: true
  end
end
