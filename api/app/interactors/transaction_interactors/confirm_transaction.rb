module TransactionInteractors
  class ConfirmTransaction < BaseInteractor
    def initialize(transaction_id)
      @transaction_id = transaction_id
    end

    def perform
      return failed(wallet_transaction.errors) if wallet_transaction.type == 'InternalTransfer'
      
      if wallet_transaction.may_succeeding?
        wallet_transaction.succeeding!
        succeeded(wallet_transaction)
      else
        wallet_transaction.failing!
        failed(wallet_transaction.errors)
      end
    end

    private

    attr_accessor :transaction_id

    def wallet_transaction
      @wallet_transaction ||= WalletTransaction.find_by(transaction_id: transaction_id)
    end
  end
end
