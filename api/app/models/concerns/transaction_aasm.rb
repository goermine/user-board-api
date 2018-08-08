module TransactionAASM
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm column: 'transaction_state' do
      state :initiate, initial: true

      state :process

      state :refuse

      state :confirm

      state :succeed

      state :fail

      event :processing, after: :notify_sender_wallet_to_block_funds do
        transitions from: :initiate, to: :process
      end

      event :refusing, after: :notify_sender_wallet_to_unblock_funds do
        transitions from: %i[initiate process], to: :refuse
      end

      event :confirming, after: :notify_beneficiary_wallet_to_charge_funds do
        transitions from: %i[initiate process], to: :confirm
      end

      event :succeeding, after: :notify_sender_wallet_to_write_off_funds do
        transitions from: :confirm, to: :succeed
      end

      event :failing, after: :notify_wallets_to_rollback do
        transitions from: :confirm, to: :fail
      end
    end
  end

  def notify_sender_wallet_to_block_funds
    return if deposit_type?
    wallet_from.block_funds(-(sum))
  end

  def notify_sender_wallet_to_unblock_funds
    return if deposit_type?
    wallet_from.unblock_funds(-(sum))
  end

  def notify_beneficiary_wallet_to_charge_funds
    return if type_withdraw?
    wallet_to.write_off_funds(sum)
  end

  def notify_sender_wallet_to_write_off_funds
    return if deposit_type?
    wallet_from.write_off_funds(-(sum))
    wallet_from.unblock_funds(-(sum))
  end

  def notify_wallets_to_rollback
    return unless internal_type?
    wallet_to.block_funds(-(sum))
    wallet_to.write_off_funds(-(sum))
    wallet_from.unblock_funds(-(sum))
  end
end
