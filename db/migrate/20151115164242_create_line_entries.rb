class CreateLineEntries < ActiveRecord::Migration
  def change
    create_table :line_entries do |t|
      t.json :data
      t.references :user, index: true, foreign_key: true
      t.references :line, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
