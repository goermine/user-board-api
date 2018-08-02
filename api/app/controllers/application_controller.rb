class ApplicationController < ActionController::API
  include ExceptionHandler
  before_action :authenticate

  private

  def authenticate
    raise ExceptionHandler::AuthenticationError, authenticate_request.errors unless logged_in?
  end

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= authenticate_request.result
  end

  def authenticate_request
    @authenticate_request ||= AuthenticateRequest.call(request.headers)
  end
end
