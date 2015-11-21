class AddSlugNameToLines < ActiveRecord::Migration
  def change
    add_column :lines, :slug_name, :string, index: true
  end
end
