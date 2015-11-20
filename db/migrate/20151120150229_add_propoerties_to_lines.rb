class AddPropoertiesToLines < ActiveRecord::Migration
  def change
    add_column :lines, :properties, :jsonb
  end
end
