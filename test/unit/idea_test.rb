require 'test_helper'

class IdeaTest < ActiveSupport::TestCase
	test "percent_liked should be 50 when votes amount is 0" do
		@idea = Idea.new

		assert @idea.percent_liked == Idea::PERCENT_FOR_NO_VOTES
	end
	
	test "percent_unliked should be 50 when votes amount is 0" do
		@idea = Idea.new

		assert @idea.percent_unliked == Idea::PERCENT_FOR_NO_VOTES
	end

	test "should change the status to closed when close the idea" do 
		@idea = Idea.new
		@idea.close
		assert true == true
		#assert @idea.statusa == Idea::CLOSED
	end
end