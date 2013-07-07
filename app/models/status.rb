class Status < ActiveRecord::Base
  attr_accessible :content, :user_id
  
  #Relationships
  belongs_to :user
end
