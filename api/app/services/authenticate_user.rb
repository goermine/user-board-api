class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    user = User.find_by(email: email.downcase)
    return auth_data(user) if user && auth_user?(user)
    errors.add(:user_authentication, 'Invalid credentials')
    nil
  end

  private

  attr_accessor :email, :password

  def auth_user?(user)
    user.authenticate(password) if user.password_digest?
  end

  def auth_data(user)
    @auth_data ||= OpenStruct.new(
      user: user,
      token: TokenAuthentication.encode(user_id: user.id)
    )
  end
end
