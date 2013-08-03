require 'test_helper'

class IdeaMailerTest < ActionMailer::TestCase
  setup do
    @comment = comments(:one)
  end
  
  test "new_comment" do
    # Send the email, then test that it got queued
    email = IdeaMailer.new_comment(@comment).deliver
    assert !ActionMailer::Base.deliveries.empty?
  end
end
