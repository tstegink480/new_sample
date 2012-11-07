class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  default_scope order: 'microposts.created_at DESC'
  
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end
  
end