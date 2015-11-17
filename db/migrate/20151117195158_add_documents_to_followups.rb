class AddDocumentsToFollowups < ActiveRecord::Migration
  def up
    add_column :followups, :documents, :json
  end
  def down
    remove_column :followups, :documents
  end
end
