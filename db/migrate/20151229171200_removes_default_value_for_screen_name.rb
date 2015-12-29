class RemovesDefaultValueForScreenName < ActiveRecord::Migration
  def change
    change_column_default(:users, :screen_name, nil)
  end
end
