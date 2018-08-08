class InternalTransferJob < ApplicationJob
  queue_as :transfer_queue
  discard_on AASM::InvalidTransition
  discard_on ActiveRecord::RecordNotFound

  def procced_transfer(transaction_id)
    transfer = WalletTransaction.find_by!(transaction_id: transaction_id)
    raise AASM::InvalidTransition unless transfer.process? && transfer.may_confirming?
    transfer.confirming!
    wallet = Wallets.find_by!(wallet_number: transfer.wallet_to.wallet_number)
    if wallet.amount_changed?
      transfer.succeeding!
    else
      transfer.failing!
    end
  end
end
