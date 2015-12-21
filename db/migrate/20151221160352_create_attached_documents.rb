class CreateAttachedDocuments < ActiveRecord::Migration
  def change
    create_table :attached_documents do |t|
      t.string :document
      t.integer :followup_id
      t.timestamps null: false
    end
  end
end
