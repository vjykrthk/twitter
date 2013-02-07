class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  VALID_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z.]+\z/i
  validates :name, presence:true, length: { maximum: 50 }
  validates :email, presence:true, format: VALID_REGEX, uniqueness: { case_sensitive:false }
  validates :password, presence:true 
  has_secure_password
  before_save { self.email.downcase! }
  before_save :set_remember_token
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, class_name: "Relationship", foreign_key: "followed_id"
  has_many :followed_users, through: :relationships, source:"followed"
  has_many :followers, through: :reverse_relationships, source:"follower"

  def feed
    Micropost.feed_for_user(self)
  end

  def follow!(followed_user)
    relationships.create!(followed_id:followed_user.id)
  end

  def unfollow!(user)
    relationships.find_by_followed_id(user.id).destroy
  end

  def following?(user)
    relationships.find_by_followed_id(user.id)
  end

  def search_posts(query)
    if query.present?
      #sanitized_query = sanitize(query)
      condition = <<-EOS
        search_post @@ '#{query}'
      EOS
      order = <<-EOS
        ts_rank_cd(search_post, '#{query}') DESC
      EOS
      microposts.where(condition).order(order)
    else
      microposts
    end
  end

  private

  	def set_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end
end
