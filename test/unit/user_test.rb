require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many :user_friendships
  should have_many :friends

  test 'User should enter First Name' do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end
  
  test 'User should enter Last Name' do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end
  
  test 'User should enter Profile Name' do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end
  
  test 'User should have a unique Profile Name' do
  	user = User.new
  	user.profile_name = users(:acib708).profile_name
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end
  
  test 'a user should have a profile name without spaces' do
    user = User.new(first_name: 'Jason', last_name: 'Seifer', email: 'jason2@teamtreehouse.com')
    user.profile_name = 'Mike The Frog'
    user.password = user.password_confirmation = 'asdfasdf'

    assert !user.save
    assert !user.errors[:profile_name].empty?
    assert user.errors[:profile_name].include?('Must be formatted correctly.')
  end

  test 'a user can have a correctly formatted profile name' do
    user = User.new(first_name: 'Jason', last_name: 'Seifer', email: 'jason2@teamtreehouse.com')
    user.password = user.password_confirmation = 'asdfasdf'

    user.profile_name = 'jasonseifer_1'
    assert user.valid?
  end

  test 'that no error is raised when trying to access a friend list' do
    assert_nothing_raised { users(:acib708).friends }
  end

  test 'that creating friendships on a user works' do
    users(:acib708).friends.push users(:tuch) #bo is already acib708's friend (specified in fixture one), chosing tuch
    users(:acib708).friends.reload
    assert users(:acib708).friends.include? users(:tuch)
  end
end
