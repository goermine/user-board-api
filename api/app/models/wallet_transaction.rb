class WalletTransaction < ApplicationRecord
  INTERNAL = 'internal'.freez
  CARD = 'card'.freez
  BANKING = 'banking'.freez

  belongs_to :wallet_to, class_name: 'Wallet'
  belongs_to :wallet_from, class_name: 'Wallet'
  belongs_to :sender, class_name: 'User'
  belongs_to :beneficiary, class_name: 'User'

  validates :sender, :beneficiary, :transaction_id, :wallet_to, :sum, :method, :type, presence: true
  validates :method, inclusion: { in: [INTERNAL, CARD, BANKING],
                                  message: "%{value} is not a method of transaction" }
  validates :sum, numericality: { greater_than: 0 }

  validates :wallet_from, presence: true, if: :internal_transaction?
  validate :wallets_currency, if: :internal_transaction?
  validate :wallet_amount

  before_validation :assign_transaction_id

  private

  def assign_transaction_id
    self.transaction_id = SecureRandom.hex(rand(20))
  end

  def internal_transaction?
    method == INTERNAL
  end

  def wallets_currency
    return if wallet_from.currency == wallet_to.currency
    errors.add(:wallet_to, 'You can`t send to wallet with different currency')
  end

  def wallet_amount
    return if wallet_from.amount >= sum
    errors.add(:wallet_to, 'You wallet doesn`t have enough funds')
  end
end
