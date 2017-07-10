class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true, null: false
      t.references :community, foreign_key: true, null: false
      t.string :text, null: false

      t.timestamps
    end
  end
end
