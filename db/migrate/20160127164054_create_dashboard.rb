class CreateDashboard < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
      t.string :dashboard_url
      t.string :dashboard_name
      t.references :line, index: true, foreign_key: true
    end
  end
end
