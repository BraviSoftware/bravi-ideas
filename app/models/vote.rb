class Vote < ActiveRecord::Base
  belongs_to :idea
  belongs_to :user
  attr_accessible :like, :user_id, :idea_id
end
