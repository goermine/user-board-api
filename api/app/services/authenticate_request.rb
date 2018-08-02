class AuthenticateRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private

  attr_reader :headers

  def user
    @user ||= User.find_by(id: decoded_auth_token.fetch('user_id', nil)) # if token_present?
  end

  def decoded_auth_token
    TokenAuthentication.decode(token)
  rescue TokenAuthentication::Expired => e
    request_error(e.message)
    {}
  rescue TokenAuthentication::Invalid => e
    request_error(e.message)
    {}
  end

  # def token_present?
  #   !!token
  # end

  def token
    headers.fetch('Authorization', '').split(' ').last
  end

  def request_error(message)
    errors.add('token', message)
  end
end
