class SessionsController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  def show
    render json: current_user
  end

  def create
    auth_service = AuthenticateUser.call(
      auth_params[:email],
      auth_params[:password]
    )

    if auth_service.success?
      headers['Auth-Token'] = auth_service.result.token
      render json: auth_service.result.user, status: 201
    else
      render json: { error: auth_service.errors }, status: 401
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end
end
