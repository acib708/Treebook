require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  context '#new' do
    context 'when not logged in' do
      should 'redirect to login page' do
        get :new
        assert_response :redirect
      end
    end

    context 'when logged in' do
      setup do
        sign_in users(:acib708)
      end

      should 'get new and return success' do
        get :new
        assert_response :success
      end

      should 'set a flash error if the friend_id params is missing' do
        get :new, {}
        assert_equal 'Friend required.', flash[:error]
      end

      should 'display friends name' do
        get :new, friend_id: users(:tuch).id
        assert_match /#{users(:tuch).full_name}/, response.body #searches for 'Ricardo Zertuche' inside the html body of the response
      end

      should 'assign a new user friendship to the correct friend' do
        get :new, friend_id: users(:tuch).id
        assert_equal users(:tuch), assigns(:user_friendship).friend
      end

      should 'assign a new user friendship to the currently logged user' do
        get :new, friend_id: users(:tuch).id
        assert_equal users(:acib708), assigns(:user_friendship).user
      end

      should 'returns 404 status if no friend is found' do
        get :new, friend_id: 'invalid'
        assert_response :not_found
      end

      should 'ask user to confirm friendship' do
        get :new, friend_id: users(:acib708)
        assert_match /Do you want to send a friend request to #{users(:acib708).full_name}?/, response.body
      end
    end
  end

  context '#create' do
    context 'when not logged in' do
      should 'redirect to the login page' do
        get :new
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context 'when logged in' do
      setup { sign_in users(:acib708) }

      context 'with no friend id' do
        setup { post :create }
        should 'set the flash error message and redirect to root path' do
          assert !flash[:error].empty?
          assert_redirected_to root_path
        end
      end

      context 'with valid friend id' do
        setup { post :create, user_friendship: { friend_id: users(:bo) } }
        should 'assign a friend object, and a user_friendship object' do
          assert assigns :friend
          assert assigns :user_friendship
        end

        should 'create a friendship' do
          assert users(:acib708).friends.include? users :bo
        end

        should 'redirect to the profile page of the added friend' do
          assert_response :redirect
          assert_redirected_to profile_path users :bo
        end

        should 'set flash message to notify friendship was successful' do
          assert flash[:success]
          assert_equal "You are now friends with #{users(:bo).full_name}!", flash[:success]
        end

      end
    end
  end
end
