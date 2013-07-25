require 'test_helper'

class AddAFriendTest < ActionDispatch::IntegrationTest
  #devise helper methods don't work in integration test
  def sign_in_as(user, password)
    post login_path, user: {email: user.email, password: password}
  end

  test 'that adding a friend workds' do
    sign_in_as users(:acib708), 'testing'

    get "/user_friendships/new?friend_id=#{users(:bo).to_param}"
    assert_response :success

    assert_difference 'UserFriendship.count', 2 do
      post '/user_friendships', user_friendship: { friend_id: users(:bo).to_param }
      assert_response :redirect
      assert_equal flash[:success], "Friend request sent to #{users(:bo).full_name}!"
    end
  end
end
