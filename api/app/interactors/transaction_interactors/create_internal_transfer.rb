module TransactionInteractors
  class CreateInternalTransfer < BaseInteractor
    def initialize(user, params)
      @user = user
      @params = params
    end

    def perform
      if wallet_transaction.save
        wallet_transaction.processing!
        InternalTransferJob.procced_transfer_later(wallet_transaction.transaction_id)
        succeeded(wallet_transaction)
      else
        wallet_transaction.refusing!
        failed(wallet_transaction.errors)
      end
    end

    private

    attr_accessor :user, :params

    def beneficiary_wallet
      @beneficiary_wallet ||= Wallet.includes(account: :user).
        find_by!(wallet_number: params[:wallet_to])
    end

    def sender_wallet
      @sender_wallet ||= Wallet.find_by!(wallet_number: params[:wallet_from])
    end

    def beneficiary
      @beneficiary ||= beneficiary_wallet.account.user
    end

    def composed_params
      params.merge(
        sender: user,
        wallet_from: sender_wallet,
        beneficiary: beneficiary,
        wallet_to: beneficiary_wallet
      )
    end

    def wallet_transaction
      @wallet_transaction ||= InternalTransfer.new(composed_params)
    end
  end
end
