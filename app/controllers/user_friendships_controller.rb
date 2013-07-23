class UserFriendshipsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user_friendships = current_user.user_friendships.all
  end

  def accept
    @user_friendship = current_user.user_friendships.find(params[:id])

    if @user_friendship.accept!
      flash[:success] = "You are now friends with #{@user_friendship.friend.full_name}!"
    else
      flash[:error] = 'Friendship could not be accepted.'
    end

    redirect_to user_friendships_path
  end

  def new
    if params[:friend_id]
      @friend = User.find(params[:friend_id])
      @user_friendship = current_user.user_friendships.new friend: @friend
    else
      flash[:error] = 'Friend required.'
    end

  rescue ActiveRecord::RecordNotFound
    render file: 'public/404', status: :not_found

  end

  def create
    if params[:user_friendship] && params[:user_friendship].has_key?(:friend_id)
      @friend = User.find(params[:user_friendship][:friend_id])
      @user_friendship = current_user.user_friendships.new friend: @friend
      @user_friendship.save
      flash[:success] = "You are now friends with #{@friend.full_name}!"
      redirect_to profile_path @friend.profile_name
    else
      flash[:error] = 'Friend required.'
      redirect_to root_path
    end
  end

  def edit
    @user_friendship = current_user.user_friendships.find(params[:id])
    @friend = @user_friendship.friend
  end

end
