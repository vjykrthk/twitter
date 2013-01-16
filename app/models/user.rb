class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  VALID_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z.]+\z/i
  validates :name, presence:true, length: { maximum: 50 }
  validates :email, presence:true, format: VALID_REGEX, uniqueness: { case_sensitive:false }
  #validates :password, presence:true 
  has_secure_password
  before_save { self.email.downcase! }
  before_save :set_remember_token

  private

  	def set_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end
end
