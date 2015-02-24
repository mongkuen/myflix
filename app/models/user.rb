class User < ActiveRecord::Base
  validates_presence_of :full_name, :email
  validates :email, uniqueness: true
  has_secure_password
end
