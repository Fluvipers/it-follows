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
  before_save :set_screen_name
  validates :role, inclusion: {in: %w(Admin Itfollowers)}

  def full_name
    "#{first_name} #{last_name}"
  end

  def is_admin?
    self.role == "Admin"
  end

  private

  def set_screen_name
    self.screen_name ||= what_screen_name
  end

  def what_screen_name
    exist_screen_name? ? set_slug_screen_name : user_username
  end

  def exist_screen_name?
    User.where(screen_name: user_username).any?
  end

  def user_username
    self.email.split("@").first 
  end

  def user_domain
    self.email.split("@").last.split(".").first
  end

  def set_slug_screen_name
    "#{user_username}_#{user_domain}"
  end
end
