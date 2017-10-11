class CreateProjectShares < ActiveRecord::Migration[5.0]
  def change
    create_table :project_shares do |t|
      t.references :user, foreign_key: true, null: false
      t.references :project, foreign_key: true, null: false
      t.string :input, null: false
      t.string :slug, null: false
      t.string :text
      t.datetime :viewed_on
      t.references :viewed_by, references: :users
      t.references :recipient, references: :users

      t.timestamps
    end

    add_index :project_shares, :slug, unique: true
    add_index :project_shares, :viewed_on
    add_reference :project_shares, :contact, foreign_key: true
    
  end
end
