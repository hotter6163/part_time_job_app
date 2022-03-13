class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  def valid_token?(digest, token)
    BCrypt::Password.new(send(digest)).is_password?(token)
  end
end
