class Status < ActiveRecord::Base
  attr_accessible :content, :user_id
  
  #Relationships
  belongs_to :user
  
  #Tests
  validates :content, presence: true, length: {minimum: 2}
  validates_presence_of :user_id
end
