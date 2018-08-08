class WalletTransaction < ApplicationRecord
  include TransactionAASM

  TYPE_DEPOSIT = 'Deposit'.freeze
  TYPE_WITHDRAW = 'Withdraw'.freeze
  TYPE_INTERNAL_TRANSFER = 'InternalTransfer'.freeze

  CHARGES_METHODS = %w[internal card banking].freeze

  belongs_to :sender, class_name: 'User'
  belongs_to :beneficiary, class_name: 'User'

  validates :sum, :charge_method, :type, presence: true
  validates :charge_method, inclusion: {
    in: [*CHARGES_METHODS, *CHARGES_METHODS.map(&:upcase), *CHARGES_METHODS.map(&:capitalize)],
    message: '%{value} is not a method of transaction'
  }
  validates :sum, numericality: { greater_than: 0 }
  validate :wallet_amount, if: :not_deposit?
  validate :transfer_between_own_wallets, if: :internal_type?

  before_create :assign_transaction_id

  private

  def assign_transaction_id
    self.transaction_id = SecureRandom.hex(rand(20))
  end

  def wallet_amount
    return if wallet_from.amount >= sum
    errors.add(:wallet_to, 'You wallet doesn`t have enough funds')
  end

  def not_deposit?
    !deposit_type?
  end

  def transfer_between_own_wallets
    return if wallet_from.account != wallet_to.account
    errors.add(:wallet_to, 'Transfer between your own wallets down`t allowed')
  end

  def deposit_type?
    type == TYPE_DEPOSIT
  end

  def type_withdraw?
    type == TYPE_WITHDRAW
  end

  def internal_type?
    type == TYPE_INTERNAL_TRANSFER
  end
end
