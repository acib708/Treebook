class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :profile_name
  # attr_accessible :title, :body
  
  #Relationships
  has_many :statuses
  
  #Tests, validation
  validates_presence_of :first_name, :last_name, :profile_name
  validates :profile_name, presence: true,
  						   uniqueness: true
  						   # format:{
# 	  						   with: /0-9a-zA-Z/,
# 	  						   message: 'Must be formatted correctly.'
#   						   }
  
  #Methods
  def full_name
  	first_name + " " + last_name
  end
end
