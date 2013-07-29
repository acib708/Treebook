require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase

  context '#index' do
    context 'when not logged in' do
      should 'redirect to login page' do
        get :index
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context 'when logged in' do
      setup do
        @friendship1 = create(:pending_user_friendship,   user: users(:acib708), friend: create(:user, first_name: 'Pending', last_name: 'Friend') )
        @friendship2 = create(:accepted_user_friendship,  user: users(:acib708), friend: create(:user, first_name: 'Active',  last_name: 'Friend') )
        @friendship3 = create(:requested_user_friendship, user: users(:acib708), friend: create(:user, first_name: 'Requested',  last_name: 'Friend') )
        @friendship4 = user_friendships(:blocked_by_acib)

        sign_in users(:acib708)
        get :index
      end

      should 'get index page without error' do
        assert_response :success
      end

      should 'assign user_friendships' do
        assert assigns :user_friendships
      end

      should 'display friends names' do
        assert_match /Active/, response.body
        assert_match /Pending/, response.body
      end

      should 'display pending information on a pending friend' do
        assert_select "#user_friendship_#{@friendship1.id}" do
          assert_select 'em', 'Friendship is pending.'
        end
      end

      context 'accepted (active) friends' do
        setup { get :index, list: 'accepted' }
        should 'get the index without error' do
          assert_response :success
        end

        should 'not display pending or requested friends' do
          assert_no_match /Pending Friend/, response.body
          assert_no_match /Requested Friend/, response.body
          assert_no_match /Blocked Friend/, response.body
        end

        should 'display blocked users names' do
          assert_match /Active Friend/, response.body
        end
      end

      context 'requested friends' do
        setup { get :index, list: 'requested' }
        should 'get the index without error' do
          assert_response :success
        end

        should 'not display pending or active friends' do
          assert_no_match /Pending Friend/, response.body
          assert_no_match /Blocked Friend/, response.body
          assert_no_match /Active Friend/, response.body
        end

        should 'display blocked users names' do
          assert_match /Requested Friend/, response.body
        end
      end

      context 'pending friends' do
        setup { get :index, list: 'pending' }
        should 'get the index without error' do
          assert_response :success
        end

        should 'not display pending or active friends' do
          assert_no_match /Requested Friend/, response.body
          assert_no_match /Blocked Friend/, response.body
          assert_no_match /Active Friend/, response.body
        end

        should 'display blocked users names' do
          assert_match /Pending Friend/, response.body
        end
      end

      context 'blocked friends' do
        setup { get :index, list: 'blocked' }
        should 'get the index without error' do
          assert_response :success
        end

        should 'not display pending, requested or active friends' do
          assert_no_match /Pending Friend/, response.body
          assert_no_match /Active Friend/, response.body
          assert_no_match /Requested Friend/, response.body
        end

        should 'display blocked users names' do
          assert_match /Blocked Friend/, response.body
        end
      end

    end

  end

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

      context 'successfully' do
        should 'create two user friendship objects' do
          assert_difference 'UserFriendship.count', 2 do
            post :create, user_friendship: { friend_id: users(:bo) }
          end
        end
      end

      context 'with valid friend id' do
        setup { post :create, user_friendship: { friend_id: users(:bo) } }
        should 'assign a friend object, and a user_friendship object' do
          assert assigns :friend
          assert assigns :user_friendship
        end

        should 'create a friendship' do
          assert users(:acib708).pending_friends.include? users :bo
        end

        should 'redirect to the profile page of the added friend' do
          assert_response :redirect
          assert_redirected_to profile_path users(:bo).profile_name
        end

        should 'set flash message to notify friendship was successful' do
          assert flash[:success]
          assert_equal "Friend request sent to #{users(:bo).full_name}!", flash[:success]
        end

      end
    end
  end

  context '#accept' do
    context 'when not logged in' do
      should 'redirect to login page' do
        put :accept, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context 'when logged in' do
      setup do
        @friend = create :user
        @user_friendship = create(:pending_user_friendship, user: users(:acib708), friend: @friend)
        create(:pending_user_friendship, friend: users(:acib708), user: @friend)
        sign_in users :acib708
        put :accept, id: @user_friendship
        @user_friendship.reload
      end

      should 'assign a user friendship' do
        assert assigns(:user_friendship)
        assert_equal @user_friendship, assigns(:user_friendship)
      end

      should 'update the state to accepted' do
        assert_equal 'accepted', @user_friendship.state
      end

      should 'have a flash success message' do
        assert_equal "You are now friends with #{@user_friendship.friend.full_name}!", flash[:success]
      end
    end
  end

  context '#edit' do
    context 'when not logged in' do
      should 'redirect to login page' do
        get :edit, id: 1
        assert_response :redirect
      end
    end

    context 'when logged in' do
      setup do
        @user_friendship = create(:pending_user_friendship, user: users(:acib708))
        sign_in users :acib708
        get :edit, id: @user_friendship.friend.profile_name
      end

      should 'get new and return success' do
        assert_response :success
      end

      should 'assign to user_friendship' do
        assert assigns :user_friendship
      end

      should 'assign to friend' do
        assert assigns :friend
      end
    end
  end

  context '#destroy' do
    context 'when not logged in' do
      should 'redirect to login page' do
        delete :destroy, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context 'when logged in' do
      setup do
        @friend = create :user
        @user_friendship = create(:pending_user_friendship, user: users(:acib708), friend: @friend)
        create(:pending_user_friendship, friend: users(:acib708), user: @friend)
        sign_in users :acib708
      end

      should 'delete user friendship and set flash message accordingly' do
        assert_difference 'UserFriendship.count', -2 do
          delete :destroy, id: @user_friendship
        end

        assert_equal flash[:success], "You are no longer friends with #{@user_friendship.friend.full_name}"

      end

    end
  end

  context '#block' do
    context 'when not logged in' do
      should 'redirect to the login page' do
        put :block, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context 'when logged in' do
      setup do
        @user_friendship = create(:pending_user_friendship, user: users(:acib708))
        sign_in users :acib708
        put :block, id: @user_friendship
        @user_friendship.reload
      end

      should 'assign a user friendship object' do
        assert assigns(:user_friendship)
        assert_equal @user_friendship, assigns(:user_friendship)
      end

      should 'update the user friendship state to blocked' do
        assert_equal 'blocked', @user_friendship.state
      end

    end

  end

end
