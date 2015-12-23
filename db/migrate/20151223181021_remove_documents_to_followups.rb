class RemoveDocumentsToFollowups < ActiveRecord::Migration
  def change
    remove_column :followups, :documents
  end
end
