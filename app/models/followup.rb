class Followup < ActiveRecord::Base
  belongs_to :line_entry
  belongs_to :user

  has_many :tasks, dependent: :destroy
  has_many :attached_documents, dependent: :destroy
  validates_presence_of :description, :percentage
  mount_uploader :document, DocumentUploader
end
