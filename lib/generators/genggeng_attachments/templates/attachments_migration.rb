class CreateGenggengAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :genggeng_attachments do |t|
      t.string :attachment_file
      t.integer :genggeng_attachmentable_id
      t.string :genggeng_attachmentable_type
      t.string :file_name

      t.timestamps
    end
  end
end
