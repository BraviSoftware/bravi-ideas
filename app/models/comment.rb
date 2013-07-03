class Comment < ActiveRecord::Base
  belongs_to :idea
  belongs_to :user
  attr_accessible :description, :idea, :user
end
