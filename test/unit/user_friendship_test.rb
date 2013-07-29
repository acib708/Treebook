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

  context '#mutual_friendship' do
    setup do
      UserFriendship.request users(:acib708), users(:bo)
      @friendship1 = users(:acib708).user_friendships.where(friend_id: users(:bo)).first
      @friendship2 = users(:bo).user_friendships.where(friend_id: users(:acib708)).first
    end

    should 'have mutual friendship' do
      assert_equal @friendship1.mutual_friendship, @friendship2
    end

  end

  context '#accept_mutual_friendship' do
    setup { UserFriendship.request users(:acib708), users(:bo) }
    should 'accept the mutual friendship' do
      friendship1 = users(:acib708).user_friendships.where(friend_id: users(:bo)).first
      friendship2 = users(:bo).user_friendships.where(friend_id: users(:acib708)).first

      friendship1.accept_mutual_friendship!
      friendship2.reload
      assert_equal friendship2.state, 'accepted'
    end
  end

  context '#accept!' do
    setup { @user_friendship = UserFriendship.request users(:acib708), users(:bo) }

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

    should 'accept the mutual friendship' do
      @user_friendship.accept!
      assert_equal @user_friendship.mutual_friendship.state, 'accepted'
    end

  end

  context '.request' do

    should 'create two user friendships' do
      assert_difference 'UserFriendship.count', 2 do
        UserFriendship.request users(:acib708), users(:tuch)
      end
    end

    should 'send a friend request email' do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        UserFriendship.request users(:acib708), users(:tuch)
      end
    end

  end

  context '#delete_mutual_friendship' do
    setup do
      UserFriendship.request users(:acib708), users(:bo)
      @friendship1 = users(:acib708).user_friendships.where(friend_id: users(:bo)).first
      @friendship2 = users(:bo).user_friendships.where(friend_id: users(:acib708)).first
    end

    should 'delete the mutual friendship' do
      assert_equal @friendship1.mutual_friendship, @friendship2
      @friendship1.delete_mutual_friendship!
      assert !UserFriendship.exists?(@friendship2)
    end
  end

  context 'on destroy' do
    setup do
      UserFriendship.request users(:acib708), users(:bo)
      @friendship1 = users(:acib708).user_friendships.where(friend_id: users(:bo)).first
      @friendship2 = users(:bo).user_friendships.where(friend_id: users(:acib708)).first
    end

    should 'destroy the mutual friendship' do
      @friendship1.destroy
      assert !UserFriendship.exists?(@friendship2)
    end

  end

  context '#block!' do
    setup { @user_friendship = UserFriendship.request users(:acib708), users(:bo) }

    should 'set the state to blocked' do
      @user_friendship.block!
      assert_equal 'blocked', @user_friendship.state
      assert_equal 'blocked', @user_friendship.mutual_friendship.state
    end

    should 'not allow new requests once blocked' do
      @user_friendship.block!
      uf = UserFriendship.request users(:acib708), users(:bo)
      assert !uf.save
    end

  end

end
