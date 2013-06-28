class Idea < ActiveRecord::Base  
  attr_accessible :created_date, :description, :negative, :positive, :title
  has_many :comments

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
end
