require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "User should enter First Name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end
  
  test "User should enter Last Name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end
  
  test "User should enter Profile Name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end
  
  test "User should have a unique Profile Name" do
  	user = User.new
  	user.profile_name = users(:acib708).profile_name
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end
  
  test "User's profile name should not have spaces" do
  	user = User.new
  	user.profile_name = "My profile with spaces"
  	
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  	assert user.errors[:profile_name].include?("Must be formatted correctly.")
  end
end
