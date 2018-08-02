class UsersController < ApplicationController
  skip_before_action :authenticate, only: :create

  def user
    render json: User.find(params[:id])
  end

  def create
    user = User.create(user_params)
    if user.save
      render json: { message: 'User created successfully' }, status: 201
    else
      render json: user.errors, status: 422
    end
  end

  def update
    if current_user.update_attributes(user_params)
      render json: current_user, status: 200
    else
      render json: current_user.errors, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
