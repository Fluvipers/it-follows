class Attachment < ActiveRecord::Base
  belongs_to :followup

  validates_presence_of :file, :followup_id
  mount_uploader :file, DocumentUploader
end
