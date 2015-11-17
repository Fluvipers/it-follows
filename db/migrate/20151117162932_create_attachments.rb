class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :followup, index: true, foreign_key: true
      t.string :file_name

      t.timestamps null: false
    end
  end
end
