class AddEmailNewsletterToPreference < ActiveRecord::Migration[5.0]
  def change
    add_column :preferences, :email_newsletter, :boolean, default: true, null: false
    add_index :preferences, :email_newsletter
  end
end
