class CreateJobReferrals < ActiveRecord::Migration[5.0]
  def change
    create_table :job_referrals do |t|
      t.references :user, foreign_key: true, null: false
      t.references :job, foreign_key: true, null: false
      t.references :sender, index: true, foreign_key: { to_table: :users }
      t.string :slug, null: false
      t.datetime :viewed_on

      t.timestamps
    end

    add_index :job_referrals, :viewed_on
    add_index :job_referrals, :slug, unique: true
    add_index :job_referrals, [:sender_id, :user_id, :job_id], unique: true, name: "job_user_sender"
  end
end
