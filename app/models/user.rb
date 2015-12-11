class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  acts_as_token_authenticatable
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :lines, dependent: :destroy
  has_many :line_entries, dependent: :destroy
  has_many :followups
  has_many :tasks

  validates_presence_of :first_name, :last_name
  mount_uploader :image, ImageUploader
end
