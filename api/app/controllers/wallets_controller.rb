class WalletTransactionsController < ApplicationController
  def show
    render json: Wallet.find_by!(wallet_number: params[:wallet_number])
  end
end
