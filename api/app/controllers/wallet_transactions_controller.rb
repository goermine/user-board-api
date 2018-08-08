class WalletTransactionsController < ApplicationController
  def index
    render json: WalletTransaction.all, status: 200
  end

  def deposit
    deposit_params = params.require(:transaction).
      permit(:wallet_to, :sum, :charge_method)

    TransactionInteractors::CreateDeposit.new(current_user, deposit_params).
      on :succeeded do |transaction|
        render json: transaction, status: 201
      end.
      on :failed do |errors|
        render json: { errors: errors }, status: 422
      end.run!
  end

  def transfer
    transfer_params = params.require(:transaction).
      permit(:wallet_from, :wallet_to, :sum, :charge_method)

    TransactionInteractors::CreateInternalTransfer.new(current_user, transfer_params).
      on :succeeded do |transaction|
        render json: transaction, status: 201
      end.
      on :failed do |errors|
        render json: { errors: errors }, status: 422
      end.run!
  end

  def withdrawal
    withdrawal_params = params.require(:transaction).
      permit(:wallet_from, :sum, :charge_method)

    TransactionInteractors::CreateWithdraw.new(current_user, withdrawal_params).
      on :succeeded do |transaction|
        render json: transaction, status: 201
      end.
      on :failed do |errors|
        render json: { errors: errors }, status: 422
      end.run!
  end

  def confirm
    TransactionInteractors::ConfirmTransaction.new(params[:transaction_id]).
      on :succeeded do |_|
        render status: 200
      end.
      on :failed do |errors|
        render json: { errors: errors }, status: 422
      end.run!
  end
end
