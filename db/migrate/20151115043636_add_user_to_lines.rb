class AddUserToLines < ActiveRecord::Migration
  def change
    add_reference :lines, :user, index: true, foreign_key: true
  end
end
