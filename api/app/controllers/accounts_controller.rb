class AccountsController < ApplicationController
  def show
    render json: Account.find_by(account_number: params[:account_number])
  end

  def create
    CreateAccountInteractor.new(current_user).
      on :succeeded do |account|
        render json: account, status: 201
      end.
      on :failed do |errors|
        render json: { errors: errors }, status: 422
      end.run!
  end
end
