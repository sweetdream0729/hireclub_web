class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.string :link
      t.string :file_uid
      t.references :attachable, polymorphic: true, null: false

      t.timestamps
    end

    change_column :attachments, :attachable_type, :string, null: false
  end
end
