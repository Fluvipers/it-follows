class CreateFollowups < ActiveRecord::Migration
  def change
    create_table :followups do |t|
      t.references :line_entry, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.text :description
      t.integer :percentage

      t.timestamps null: false
    end
  end
end
