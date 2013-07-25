require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    session[:user_id] = @user.id
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get ideas" do
  	get :ideas, :format => "json"
    assert_response :success
    assert_not_nil assigns(:ideas)
  end
  
  test "should get ideas sorted by more rated" do
    get :ideas, :format => "json", sort_type: "rated"
    assert_response :success
    assert_not_nil assigns(:ideas)
  end
  
  test "should get ideas sorted by more liked" do
    get :ideas, :format => "json", sort_type: "liked"
    assert_response :success
    assert_not_nil assigns(:ideas)
  end
  
  test "should get ideas sorted by more commented" do
    get :ideas, :format => "json", sort_type: "commented"
    assert_response :success
    assert_not_nil assigns(:ideas)
  end
  
  test "should get ideas sorted by more unliked" do
    get :ideas, :format => "json", sort_type: "unliked"
    assert_response :success
    assert_not_nil assigns(:ideas)
  end  

  test "should get comments" do
  	get :comments, :format => "json"
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test "should add comment" do
  	@comment = comments(:one)

  	assert_difference('Comment.count') do
      post :add_comment, :format => "json", comment: {
        description: @comment.description,
        idea_id: @comment.idea_id
      }
    end

    assert_response :created
    assert_not_nil assigns(:comment)
  end

  test "should not allow not authenticated users add comment" do
  	@comment = comments(:one)
  	session[:user_id] = nil # invalid user
  	
		post :add_comment, :format => "json", comment: {
			description: @comment.description,
			idea_id: @comment.idea_id
		}

    assert_response :unauthorized
    assert_nil assigns(:comment)
  end

  test "should remove comment" do
  	@comment = comments(:one)

    assert_difference('Comment.count', -1) do
      delete :remove_comment, id: @comment.id, :format => "json"
    end

    assert_response :no_content
  end

end
