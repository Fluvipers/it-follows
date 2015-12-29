class RemovePropertiesFromLines < ActiveRecord::Migration
  def change
    remove_column :lines, :properties, :jsonb
  end
end
