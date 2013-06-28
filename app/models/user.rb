class User < ActiveRecord::Base
  has_many :comments
  attr_accessible :email, :name
end
