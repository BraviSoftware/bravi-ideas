require 'test_helper'

class IdeasControllerTest < ActionController::TestCase
  setup do
    @idea = ideas(:one)
    session[:user_id] = @idea.user_id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ideas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create idea" do
    assert_difference('Idea.count') do
      post :create, idea: {
        description: @idea.description,
        title: @idea.title
      }
    end

    assert_redirected_to idea_path(assigns(:idea))
  end

  test "should show idea" do
    get :show, id: @idea
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @idea
    assert_response :success
  end

  test "should update idea" do
    put :update, id: @idea, idea: { 
      created_date: @idea.created_date, 
      description: @idea.description, 
      negative: @idea.negative, 
      positive: @idea.positive, 
      title: @idea.title 
    }
    assert_redirected_to idea_path(assigns(:idea))
  end

  test "should destroy idea" do
    assert_difference('Idea.count', -1) do
      delete :destroy, id: @idea.id
    end

    assert_redirected_to ideas_path
  end

  test "should like idea" do
    assert_difference("Vote.count") do
      put :like, :format => "json", id: @idea.id
    end

    assert_response :no_content
  end

  test "should unlike idea" do
    assert_difference("Vote.count") do
      put :unlike, :format => "json", id: @idea.id
    end

    assert_response :no_content
  end
end
