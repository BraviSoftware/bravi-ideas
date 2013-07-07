class Idea < ActiveRecord::Base
  OPEN = 0
  CLOSED = 1
  ALL_STATUS = { OPEN => "Open", CLOSED => "Closed" }
  PERCENT_FOR_NO_VOTES = 50

  has_many :comments
  has_many :votes
  belongs_to :user

  attr_accessible :created_date, :description, :negative, :positive, :title, :status, :user_id
  
  def like
    self.increment(:positive)
  end

  def unlike
    self.increment(:negative)
  end

  def get_status_label
    ALL_STATUS[self.status]
  end

  def close
    self.status = CLOSED
  end

  def percent_liked
    calculate_percent self.positive
  end

  def percent_unliked
    calculate_percent self.negative
  end
  
  def self.all_and_current_user_voted(user_id = 0)
    if user_id.is_a? Integer
      Idea.select("ideas.id, description, negative, positive, title, 
                  ideas.user_id, image as user_image, 
                  votes.user_id as current_user_id_voted").
        joins("inner join users on ideas.user_id = users.id 
                  left outer join votes on ideas.id = votes.idea_id 
                  and votes.user_id = #{user_id}").
        where("status = ?", OPEN).
        order("ideas.id")
    else
      raise "user_id must be a Integer"
    end
  end


  private
  def total
    (self.positive || 0) + (self.negative || 0)
  end

  def calculate_percent(totalType)
    total == 0 ? PERCENT_FOR_NO_VOTES : ((totalType * 100 ) / total)
  end
  
  before_save do
    self.negative ||= 0
    self.positive ||= 0
    self.created_date ||= Time.now
    self.status ||= 0
  end

  after_initialize do
    if self.new_record?
      self.negative ||= 0
      self.positive ||= 0
    end
  end
end