class CreatePreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :preferences do |t|
      t.references :user, foreign_key: true, null: false, index: false
      t.boolean :email_on_follow, null: false, default: true
      t.boolean :email_on_comment, null: false, default: true
      t.boolean :email_on_mention, null: false, default: true

      t.timestamps
    end

    add_index :preferences, :email_on_follow
    add_index :preferences, :email_on_comment
    add_index :preferences, :email_on_mention

    add_index :preferences, :user_id, unique: true
  end
end
