class UserFrienshipAddState < ActiveRecord::Migration
  def change
    add_column :user_friendships, :state, :string
    add_index :user_friendships, :stater
  end
end
