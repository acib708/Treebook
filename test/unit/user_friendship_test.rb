require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  should belong_to :user
  should belong_to :friend

  test 'that creating a friendship works without raising an exception' do
    assert_nothing_raised do
      UserFriendship.create user: users(:acib708), friend: users(:bo)
    end
  end

  test 'that creating a friendship based on user id and friend id works' do
    UserFriendship.create user_id: users(:acib708).id, friend_id: users(:tuch).id
    assert users(:acib708).pending_friends.include? users :tuch
  end

  context 'a new instance' do
    setup { @user_friendship = UserFriendship.new user: users(:acib708), friend: users(:bo) }

    should 'have a pending state' do
      assert_equal 'pending', @user_friendship.state
    end

  end

  context '#send_request_email' do
    setup { @user_friendship = UserFriendship.create user: users(:acib708), friend: users(:bo) }

    should 'send email' do
      assert_difference('ActionMailer::Base.deliveries.size', 1) { @user_friendship.send_request_email }
    end
  end

  context '#accept!' do
    setup { @user_friendship = UserFriendship.create user: users(:acib708), friend: users(:bo) }

    should 'set state to accepted' do
      @user_friendship.accept!
      assert_equal 'accepted', @user_friendship.state
    end

    should 'send acceptance email' do
      assert_difference('ActionMailer::Base.deliveries.size', 1) { @user_friendship.accept! }
    end

    should 'include friend in list of friends' do
      @user_friendship.accept!
      users(:acib708).friends.reload
      assert users(:acib708).friends.include? users :bo
    end

  end
end
