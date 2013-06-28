class Comment < ActiveRecord::Base
  belongs_to :idea, :user
  attr_accessible :description
end
