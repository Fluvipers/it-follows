class AttachedDocument < ActiveRecord::Base
  belongs_to :followup
  validates_presence_of :document
  validates_presence_of :followup_id

  mount_uploader :document, DocumentUploader
end
