require 'test_helper'

class CustomRoutesTest < ActionDispatch::IntegrationTest
  test "/login route opens the login page" do
  	get '/login'
  	assert_response :success
  end
  
  test "/logout route logs you out when logged in" do
  	get '/logout'
  	assert_response :redirect
  	assert_redirected_to '/'
  end
  
  test "/register route opens the sign up page" do
  	get '/register'
  	assert_response :success
  end
  
  test "that a profile page works" do
  	get '/acib708'
  	assert_response :success
  end
end
