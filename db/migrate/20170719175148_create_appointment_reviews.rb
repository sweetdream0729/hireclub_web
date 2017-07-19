class CreateAppointmentReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :appointment_reviews do |t|
      t.references :user, foreign_key: true, null: false
      t.references :appointment, foreign_key: true, null: false
      t.integer :rating, null: false
      t.text :text
      

      t.timestamps
    end

    add_index :appointment_reviews, :rating
  end
end
