class CreateNewsletters < ActiveRecord::Migration[5.0]
  def change
    create_table :newsletters do |t|
      t.string :name
      t.string :campaign_id
      t.datetime :sent_on
      t.string :subject, null: false
      t.string :preheader
      t.text :html

      t.timestamps
    end
  end
end
