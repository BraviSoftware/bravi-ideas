class Idea < ActiveRecord::Base
  attr_accessible :created_date, :description, :negative, :positive, :title
end
