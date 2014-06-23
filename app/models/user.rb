class User < ActiveRecord::Base

  validates :login, presence: true
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true
  has_many :pages

  def password_valid?(pass)
    computed_pass = Digest::SHA2.hexdigest(self.salt + pass)
    if (computed_pass != self.password_digest)
      return false
    end
    return true
  end

  def password
    @password
  end

  def password=(input)
    @password = input
    self.salt = SecureRandom.hex
    self.password_digest = Digest::SHA2.hexdigest(self.salt + input)
  end

  def password_confirmation
    @password_confirmation
  end

  def password_confirmation=(input)
    @password_confirmation = input
  end

end
