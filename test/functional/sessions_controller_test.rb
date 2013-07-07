require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    session[:user_id] = 1
  end

  test "should create user" do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = omniauth_auth_fake
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook] 
    
    assert_difference('User.count') do
      post :create
    end

    assert_redirected_to root_url
  end

  test "should destroy user session" do
    delete(:destroy, {}, {'user_id' => 5})
    assert_nil session[:user_id]
    assert_redirected_to root_url
  end

  private
  def omniauth_auth_fake
    {
      :provider => 'facebook',
      :uid => '1234567',
      :info => {
        :nickname => 'jbloggs',
        :email => 'joe@bloggs.com',
        :name => 'Joe Bloggs',
        :first_name => 'Joe',
        :last_name => 'Bloggs',
        :image => 'http://graph.facebook.com/1234567/picture?type=square',
        :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
        :location => 'Palo Alto, California',
        :verified => true
      },
      :credentials => {
        :token => 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
        :expires_at => 1321747205, # when the access token expires (it always will)
        :expires => true # this will always be true
      }      
    }
  end 
end