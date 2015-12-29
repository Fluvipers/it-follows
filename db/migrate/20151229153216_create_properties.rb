class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name
      t.string :data_type
      t.boolean :required, default: false
      t.integer :line_id

      t.timestamps null: false
    end
  end
end
