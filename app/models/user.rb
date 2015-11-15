class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :lines, dependent: :destroy
  has_many :line_entries, dependent: :destroy
  validates_presence_of :first_name, :last_name
end
