class CreateCommunityMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :community_members do |t|
      t.references :community, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.string :role, null: false

      t.timestamps
    end

    add_index :community_members, [:user_id, :community_id], unique: true
    add_index :community_members, :role
  end
end
