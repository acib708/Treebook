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
    assert users(:acib708).friends.include? users(:tuch)
  end
end
