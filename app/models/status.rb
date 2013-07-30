class Status < ActiveRecord::Base
  attr_accessible :content, :user_id, :document_attributes
  
  #Relationships
  belongs_to :user
  belongs_to :document

  accepts_nested_attributes_for :document

  #Tests
  validates :content, presence: true, length: {minimum: 2}
  validates_presence_of :user_id
end
