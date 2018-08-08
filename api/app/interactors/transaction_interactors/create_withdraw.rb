module TransactionInteractors
  class CreateWithdraw < BaseInteractor
    def initialize(user, params)
      @user = user
      @params = params
    end

    def perform
      if wallet_transaction.save
        wallet_transaction.processing!
        succeeded(wallet_transaction)
      else
        wallet_transaction.refusing!
        failed(wallet_transaction.errors)
      end
    end

    private

    attr_accessor :user, :params

    def sender_wallet
      @sender_wallet ||= Wallet.find_by!(wallet_number: params[:wallet_from])
    end

    def composed_params
      params.merge(
        sender: user,
        beneficiary: user,
        wallet_from: sender_wallet
      )
    end

    def wallet_transaction
      @wallet_transaction ||= Withdraw.new(composed_params)
    end
  end
end
