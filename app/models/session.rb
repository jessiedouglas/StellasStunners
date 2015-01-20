class Session < ActiveRecord::Base
  validates :user, :token, presence: true
  validates :token, uniqueness: true
  
  before_validation :ensure_token
  
  belongs_to :user, inverse_of: :sessions
  
  def self.generate_session_token
    loop do
      token = SecureRandom::urlsafe_base64(16)
      unless Session.find_by_token(token)
        return token
      end
    end
  end
  
  def self.find_user_by_session_token(token)
    session = Session.find_by_token(token)
    session.user
  end
  
  private
  def ensure_token
    self.token = Session.generate_session_token
  end
end
