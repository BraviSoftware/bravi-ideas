class Idea < ActiveRecord::Base
  OPEN = 0
  CLOSED = 1
  ALL_STATUS = { OPEN => "Open", CLOSED => "Closed" }
  PERCENT_FOR_NO_VOTES = 50

  has_many :comments
  has_many :votes
  belongs_to :user
  
  attr_reader :status
  attr_accessible :created_date, :description, :negative, :positive, :title, :status, :user_id
  
  def initialize
    @negative = 0
    @positive = 0
  end

  before_save :default_values
  def default_values
    @negative ||= 0
    @positive ||= 0
    @created_date ||= Time.now
    @status ||= 0
  end

  def like
    @positive += 1
  end

  def unlike
    @negative += 1
  end

  def get_status_label
    ALL_STATUS[@status]
  end

  def close
    @status = CLOSED
  end


  def percent_liked
    calculate_percent @positive
  end

  def percent_unliked
    calculate_percent @negative
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
    @positive + @negative
  end

  def calculate_percent(totalType)
    total == 0 ? PERCENT_FOR_NO_VOTES : ((totalType * 100 ) / total)
  end
end