class Comment < ActiveRecord::Base
	belongs_to :idea
	belongs_to :user
	attr_accessible :description, :idea_id, :user_id

	def self.get_comment_and_its_user_image(comment_id)
		where(id: comment_id)
		.joins(:user)
		.select('comments.*, image as user_image')
		.first
	end
end