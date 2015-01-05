class User < ActiveRecord::Base
  validates :username, :email, :user_type, :password_digest, :session_token, presence: true
  validates :username, :email, uniqueness: true
  validates :user_type, inclusion: { in: ["Student", "Teacher", "Admin"] }
  validates :password, length: { minimum: 8, allow_nil: true }
  
  after_initialize :ensure_session_token
  
  attr_reader :password
  
  def self.generate_session_token
    loop do
      token = SecureRandom::urlsafe_base64(16)
      if !User.find_by_session_token(token)
        return token
      end
    end
  end
  
  def self.find_by_credentials(un_or_email, password)
    user = User.find_by_username_or_email(un_or_email)
    return nil if user.nil?
    
    return user if user.is_password?(password)
    
    nil
  end
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
  
  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end
  
  private
  def self.find_by_username_or_email(un_or_email)
    user = User.find_by_username(un_or_email)
    return user unless user.nil?
    
    User.find_by_email(un_or_email)
  end
  
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end
end
