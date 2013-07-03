class Idea < ActiveRecord::Base
  has_many :comments
  has_many :votes
  belongs_to :user
  
  attr_accessible :created_date, :description, :negative, :positive, :title
  
  before_save :default_values
  def default_values
  	self.negative ||= 0
  	self.positive ||= 0
  	self.created_date ||= Time.now
  end


  def like
  	self.positive += 1
  end

  def unlike
  	self.negative += 1
  end

  def total
    self.positive + self.negative
  end

  def percentPositive
    if self.total() == 0
      return 50
    end

    (self.positive * 100 ) / self.total()
  end

  def percentNegative
    if self.total() == 0
      return 50
    end

    (self.negative * 100 ) / self.total()
  end

  def self.allAndCurrentUserVoted(user_id)
    find(
      :all, 
      :select => "ideas.id, ideas.description, ideas.negative, ideas.positive, ideas.title, users.image as user_image, votes.user_id as current_user_id_voted",
      :joins => "inner join users on ideas.user_id = users.id left outer join votes on ideas.id = votes.idea_id and votes.user_id = #{user_id}",
      :order  => "ideas.id"
    )
  end
end