class InternalTransfer < WalletTransaction
  belongs_to :wallet_to, class_name: 'Wallet', foreign_key: 'wallet_to'
  belongs_to :wallet_from, class_name: 'Wallet', foreign_key: 'wallet_from'

  validates :wallet_to,  :sender, :beneficiary, :wallet_from, presence: true
  validate :wallets_currency

  def wallets_currency
    return if wallet_from.currency == wallet_to.currency
    errors.add(:wallet_to, 'You can`t send to wallet with different currency')
  end
end
