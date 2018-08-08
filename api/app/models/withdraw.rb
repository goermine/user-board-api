class Withdraw < WalletTransaction
  belongs_to :wallet_from, class_name: 'Wallet', foreign_key: 'wallet_from'
  validates :wallet_from, :sender, presence: true
end
