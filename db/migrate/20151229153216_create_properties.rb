class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name
      t.string :data_type, default: 'String'
      t.boolean :required, default: false
      t.references :line, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
