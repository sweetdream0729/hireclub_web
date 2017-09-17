class AddEmailListToNewsletter < ActiveRecord::Migration[5.0]
  def change
    add_reference :newsletters, :email_list, foreign_key: true
  end
end
