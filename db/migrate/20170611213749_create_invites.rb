class CreateInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :invites do |t|
      t.references :user, foreign_key: true, null: false
      t.string :input, null: false
      t.string :slug, null: false
      t.datetime :viewed_on
      t.text :text
      t.references :viewed_by, references: :users

      t.timestamps
    end

    add_index :invites, :slug, unique: true
    add_index :invites, :viewed_on
  end
end
