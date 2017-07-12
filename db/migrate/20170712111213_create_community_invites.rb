class CreateCommunityInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :community_invites do |t|
      t.references :community, foreign_key: true, index: true, null: false
      t.references :sender, foreign_key: { to_table: :users }, index: true, null: false
      t.references :user, foreign_key: true, index: true, null: false
      t.string :slug, null: false
      t.datetime :accepted_on
      t.datetime :declined_on

      t.timestamps
    end
    
    add_index :community_invites, :slug, unique: true
    add_index :community_invites, [:community_id, :sender_id, :user_id], unique: true, name: "sender_user"
  end
end
