class AddScreenNameToUsers < ActiveRecord::Migration
  def  up
    add_column :users, :screen_name, :string, :default => 'fluvip'
  end
  def down
    remove_column :users, :screen_name
 end
end
