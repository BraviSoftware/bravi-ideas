require 'test_helper'

class IdeaTest < ActiveSupport::TestCase
	test "percent_liked should be 50 when votes amount is 0" do
		@idea = Idea.new

		assert @idea.percent_liked == Idea::PERCENT_FOR_NO_VOTES
	end

	test "percent_liked should be 100 when liked vote is 1 and unliked vote is 0" do
		@idea = Idea.new
		
		@idea.like 

		assert @idea.percent_liked == 100, @idea.percent_liked.to_s
	end

	test "percent_liked should be 66 when liked vote is 2 and unliked vote is 1" do
		@idea = Idea.new

		@idea.like 
		@idea.like
		@idea.unlike

		assert @idea.percent_liked == 66, @idea.percent_liked.to_s
	end

	test "percent_liked should be 66 when liked vote is 1 and unliked vote is 2" do
		@idea = Idea.new

		@idea.unlike 
		@idea.unlike
		@idea.like

		assert @idea.percent_unliked == 66, @idea.percent_liked.to_s
	end
	
	test "percent_unliked should be 50 when votes amount is 0" do
		@idea = Idea.new

		assert @idea.percent_unliked == Idea::PERCENT_FOR_NO_VOTES
	end

	test "should change the status to closed when close the idea" do 
		@idea = Idea.new
		@idea.close
		assert @idea.status == Idea::CLOSED
	end

	test "should increase 1 liked vote when an user like a idea" do
		@idea = Idea.new

		@idea.like

		assert @idea.positive == 1
	end

	test "should increase 1 unliked vote when an user unlike a idea" do
		@idea = Idea.new

		@idea.unlike

		assert @idea.negative == 1
	end


end