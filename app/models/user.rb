class User < ActiveRecord::Base

  has_many :pages

  def password_valid?(pass)
    computed_pass = Digest::SHA2.hexdigest(self.salt + pass)
    if (computed_pass != self.password_digest)
      return false
    end
    return true
  end

  def password
  end

  def password=(input)
    self.salt = SecureRandom.hex
    self.password_digest = Digest::SHA2.hexdigest(self.salt + input)
  end

end
