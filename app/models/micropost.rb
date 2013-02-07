class Micropost < ActiveRecord::Base
  attr_accessible :content, :in_reply_to
  belongs_to :user
  validates :content, presence:true, length: { maximum: 140 }
  validates :user_id, presence:true
  default_scope order: "created_at DESC"
  #scope :including_replies, where(in_reply_to:id)

  def including_replies
  	Micropost.where(in_reply_to:id)
  end

  def self.feed_for_user(user)
  	followed_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
  	where("user_id IN (#{followed_ids}) OR user_id = :user_id", user_id: user.id)
  end
end
