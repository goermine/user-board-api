class Deposit < WalletTransaction
  belongs_to :wallet_to, class_name: 'Wallet', foreign_key: 'wallet_to'
  validates :wallet_to, :beneficiary, presence: true
end
