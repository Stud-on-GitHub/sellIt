class User < ApplicationRecord
  has_secure_password

  has_many :classifieds
  
  # validates :fullname, :username, :password_digest, presence: true
  # validates :username, uniqueness: true
  # or
  validates_presence_of :fullname, :username, :password_digest
  validates_uniqueness_of :username

  # Allow to use the username instead of email (knock default)
  def self.from_token_request(request)
    username = request.params['auth'] && request.params['auth']['username']
    self.find_by(username: username)
  end
end
