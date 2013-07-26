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
    calculate_percent(self.positive)
  end

  def percent_unliked
    calculate_percent(self.negative)
  end
  
  def self.all_and_current_user_voted(user_id = 0, sortType = nil)
    user_id = 0 unless user_id.is_a? Integer
    
    select("ideas.id, description, negative, positive, title, 
                ideas.user_id, name as user_name, image as user_image, 
                votes.user_id as current_user_id_voted,
                (positive + negative) as votes_amount,
                (select count(cm.idea_id) from comments cm where cm.idea_id = ideas.id) as comments_amount").
      joins("inner join users on ideas.user_id = users.id 
              left outer join votes on ideas.id = votes.idea_id 
                and votes.user_id = #{user_id}").
      where("status = ?", OPEN).
      order(ideas_sort_criteria(sortType))
  end

  def self.add_vote(idea_id, liked, user_id)
    @idea = Idea.find(idea_id)

    if liked
      @idea.like()
      @idea.update_attribute :positive, @idea.positive
    else
      @idea.unlike()
      @idea.update_attribute :negative, @idea.negative
    end

    Vote.create like: liked, user_id: user_id, idea_id: idea_id
  end


  private
  def total
    (self.positive || 0) + (self.negative || 0)
  end

  def calculate_percent(totalType)
    total == 0 ? PERCENT_FOR_NO_VOTES : ((totalType * 100 ) / total)
  end
  
  def self.ideas_sort_criteria(sortType)
    default_sort = "ideas.id DESC"
    case sortType
      when "rated" then "votes_amount DESC, #{default_sort}"
      when "liked" then "positive DESC, #{default_sort}"
      when "unliked" then "negative DESC, #{default_sort}"
      when "commented" then "comments_amount DESC, #{default_sort}"
      else default_sort
    end
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