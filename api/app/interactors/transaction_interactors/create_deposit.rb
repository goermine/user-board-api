module TransactionInteractors
  class CreateDeposit < BaseInteractor
    def initialize(user, params = {})
      @user = user
      @params = params
    end

    def perform
      if wallet_transaction.save
        wallet_transaction.confirming!
        succeeded(wallet_transaction)
      else
        wallet_transaction.refusing!
        failed(wallet_transaction.errors)
      end
    end

    private

    attr_accessor :user, :params

    def beneficiary_wallet
      @beneficiary_wallet ||= Wallet.find_by!(wallet_number: params[:wallet_to])
    end

    def composed_params
      params.merge(
        sender: user,
        beneficiary: user,
        wallet_to: beneficiary_wallet
      )
    end

    def wallet_transaction
      @wallet_transaction ||= Deposit.new(composed_params)
    end
  end
end
