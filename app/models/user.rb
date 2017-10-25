class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Relations
  has_many :tasks

  validates_uniqueness_of :auth_token
  before_create :generate_authentication_token!

  def info
    # You only need to use 'self.' before the field 
    # if you want to modify its value
    "#{email} - #{created_at} - Token: #{Devise.friendly_token}"
  end

  def generate_authentication_token!
    generated_token = Devise.friendly_token
    self.auth_token = User.find_by_auth_token(generated_token) ? generate_authentication_token! : generated_token
    # Could also be
    # begin
    #   self.auth_token = Devise.friendly_token
    # end while User.exists(auth_token: self.auth_token)
  end
end
