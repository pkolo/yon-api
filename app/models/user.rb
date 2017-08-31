class User < ApplicationRecord
  has_secure_password
  has_secure_token

  # This method is not available in has_secure_token
  def invalidate_token
    self.update_columns(token: nil)
  end

  def self.valid_login?(name, password)
    user = find_by(name: name)
    if user && user.authenticate(password)
      user
    end
  end
end
