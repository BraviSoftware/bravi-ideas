class Idea < ActiveRecord::Base
  has_many :comments
  has_many :votes
  belongs_to :user
  
  attr_accessible :created_date, :description, :negative, :positive, :title, :status, :user_id
  
  before_save :default_values
  def default_values
  	self.negative ||= 0
  	self.positive ||= 0
  	self.created_date ||= Time.now
    self.status ||= 0
  end


  def like
  	self.positive += 1
  end

  def unlike
  	self.negative += 1
  end

  @@all_status = { 0 => "Open", 1 => "Closed" }
  def self.all_status
    @@all_status
  end

  def get_status_label
    @@all_status[self.status]
  end

  def close
    self.status = 1 #closed
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

  
  def self.all_and_current_user_voted(user_id)
    user_id ||= 0
    find(
      :all, 
      :select => "ideas.id, description, negative, positive, title, ideas.user_id, image as user_image, votes.user_id as current_user_id_voted",
      :joins => "inner join users on ideas.user_id = users.id left outer join votes on ideas.id = votes.idea_id and votes.user_id = #{user_id}",
      :order  => "ideas.id",
      :conditions => "status = 0"
    )
  end
end