class Idea < ActiveRecord::Base
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
end
