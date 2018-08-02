module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end

  included do
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { error: e.message }, status: 404
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { error: e.message }, status: 422
    end
  end

  private

  def unauthorized_request(e)
    render json: { error: e.message || 'Invalid auth token' }, status: 401
  end
end
