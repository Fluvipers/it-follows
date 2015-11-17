class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :followup, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.text :description
      t.boolean :completed

      t.timestamps null: false
    end
  end
end
